import {ExpressRequest, ExpressResponse, User} from "./typescript_types";
import {MysqlSession, MysqlStmt, MysqlSelectStmt, Table} from './database';
import * as database from "./database";
import Cors from 'cors'

export function initMiddleware(middleware: any) {
  return (req: ExpressRequest, res: ExpressResponse<any>) =>
    new Promise((resolve, reject) => {
      middleware(req, res, (result: any) => {
        if (result instanceof Error) {
          return reject(result)
        }
        return resolve(result)
      })
    })
}

const cors = initMiddleware(Cors({methods: ['GET', 'POST'],}))

/*
 * Used to create basic API endpoint functions.
 * Converts request bodies into json objects and adds response functions
 */
export function createHandler(callback: (body: any, res: ExpressResponse<any>) => Promise<void>): (req: ExpressRequest, res: ExpressResponse<any>) => Promise<void> {
	return async (req: ExpressRequest, res: ExpressResponse<any>) => {
		await cors(req, res);
		initializeAPIRequest(req, res);
		await callback(req.body, res);
	}
}

/*
 * Used to create API endpoint functions.
 * Converts request bodies into json objects, adds response functions
 * and opens a connection to a mysql server.
 */
export function createHandlerWithMysql(callback: (body: any, res: ExpressResponse<any>, mysqlSession: MysqlSession) => Promise<void>): (req: ExpressRequest, res: ExpressResponse<any>) => Promise<void> {
	return createHandler(async (body: any, res: ExpressResponse<any>) => {
		var session: MysqlSession;
		try {
			 session = await database.mysqlGetSession();
		} catch(e) {
			res.respondException(e, "W-1");
			return;
		}
		try {
			await callback(body, res, session);
		} catch(e) {
			res.respondException(e, "W-2");
		}
		session.release();
	});
}

var mysqlStmtFindSession: MysqlStmt = new MysqlSelectStmt()
	.setTable(Table.Sessions)
	.joinTable(Table.Users, "users.user_id = sessions.user_id")
	.joinTable(Table.Vendors, "users.user_id = vendors.owner_user_id")
	.setFields([
		"sessions.session_id",
		"users.user_id",
		"users.user_type",
		"users.name",
		"users.user_type = 'vendor' AS user_is_vendor",
		"vendors.vendor_id AS vendor_id"
	])
	.addCondition("sessions.session_id = ?")
	.addCondition("sessions.session_code = ?")
	.compileQuery();

/*
 * Used to create API endpoint functions.
 * Converts request bodies into json objects, adds response functions
 * and opens a connection to a mysql server.
 */
export function createHandlerWithSession(callback: (body: any, res: ExpressResponse<any>, mysqlSession: MysqlSession, user: User) => Promise<void>): (req: ExpressRequest, res: ExpressResponse<any>) => Promise<void> {
	return createHandlerWithMysql(async (body: {session_full_code: string}, res: ExpressResponse<any>, session: MysqlSession) => {
		if(!body.session_full_code || !(typeof body.session_full_code === 'string')) {
            res.respondRequireLogin("W-3");
			return;
		}
        var session_items: Array<string> = body.session_full_code.split(":");
        if(session_items.length != 2) {
            res.respondRequireLogin("W-3");
            return;
        }
		var session_id = session_items[0];
		var session_code = session_items[1];
		await mysqlStmtFindSession.execute(session, [session_id, session_code])
			.then(async (result: Array<User>) => {
				if(result.length == 0) {
					// Invalid session code
                    res.respondRequireLogin("W-4");
					return;
				}
                console.log(result);
				var user: User = result[0];
				try {
					await callback(body, res, session, user);
				} catch(e) {
					res.respondException(e, "W-5");
				}
			})
			.catch((e) => {
				// Should only occur if something
				// is wrong with the sql query.
				res.respondException(e, "W-6");
			});
	});
}

export function initializeAPIRequest(req: ExpressRequest, res: ExpressResponse<any>): void {
	integrateResponseFunctions(res);
	if(!req.body) {
		res.respondFail("W-0");
	}
}

export function integrateResponseFunctions(res: ExpressResponse<any>): void {
	const resConst = res;
	// Run when a request fails.
	res.respondFail = (errorCode: string, msg=null) => {
		if(resConst.responded) return;
		resConst.responded = true;

		resConst.status(400);
		resConst.setHeader('Access-Control-Allow-Origin', '*');
		resConst.setHeader('Content-Type', 'application/json');
		if(msg) {
			resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode, data:{msg: msg}}));
		} else {
			resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode}));
		}
	}
	// Runs when a user needs to login to access the specified page.
	res.respondRequireLogin = (errorCode: string) => {
		if(resConst.responded) return;
		resConst.responded = true;

		resConst.status(400);
		resConst.setHeader('Access-Control-Allow-Origin', '*');
		resConst.setHeader('Content-Type', 'application/json');
		resConst.end(JSON.stringify({success: false, needLogin: true, errorCode: errorCode}));
	}
	// Run when an exception occurs.
	res.respondException = (exception, errorCode) => {
		if(resConst.responded) return;
		resConst.responded = true;

		console.log(exception);
		resConst.status(500);
		resConst.setHeader('Access-Control-Allow-Origin', '*');
		resConst.setHeader('Content-Type', 'application/json');
		resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode}));
	}
	// Run when a request succeeds. Can optionally send data back
	res.respondSuccess = (data?: any) => {
		if(resConst.responded) return;
		resConst.responded = true;

		if(data) {
			resConst.status(200);
			resConst.setHeader('Access-Control-Allow-Origin', '*');
			resConst.setHeader('Content-Type', 'application/json');
			resConst.end(JSON.stringify({success: true, data: data}));
			return;
		} else {
			resConst.status(200);
			resConst.setHeader('Access-Control-Allow-Origin', '*');
			resConst.setHeader('Content-Type', 'application/json');
			resConst.end(JSON.stringify({success: true}));
		}
	}

}
