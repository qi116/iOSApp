import {ExpressRequest, ExpressResponse} from "./typescript_types";
import {MysqlSession, MysqlStmt, MysqlSelectStmt, Table} from './database';
import * as database from "./database";

/*
 * Used to create basic API endpoint functions.
 * Converts request bodies into json objects and adds response functions
 */
export function createHandler(callback: (body: any, res: ExpressResponse<any>) => Promise<void>): (req: ExpressRequest, res: ExpressResponse<any>) => Promise<void> {
	return async (req: ExpressRequest, res: ExpressResponse<any>) => {
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
			console.log(e);
			return;
		}
		try {
			await callback(body, res, session);
		} catch(e) {
			console.log(e);
		}
		session.release();
	});
}

var mysqlStmtSelectUser: MysqlStmt = new MysqlSelectStmt()
	.setTable(Table.Sessions)
	.joinTable(Table.Users, "users.user_id = sessions.user_id")
	.setFields(["users.user_id", "users.name"])
	.addCondition("sessions.session_code = ?")
	.compileQuery();

/*
 * Used to create API endpoint functions.
 * Converts request bodies into json objects, adds response functions
 * and opens a connection to a mysql server.
 */

export function createHandlerWithLogin(callback: (body: any, res: ExpressResponse<any>, mysqlSession: MysqlSession, user: null) => Promise<void>): (req: ExpressRequest, res: ExpressResponse<any>) => Promise<void> {
	return createHandlerWithMysql(async (body: any, res: ExpressResponse<any>) => {
		var session: MysqlSession;
		try {
			 session = await database.mysqlGetSession();
		} catch(e) {
			console.log(e);
			return;
		}

		try {
			await callback(body, res, session, null);
		} catch(e) {
			console.log(e);
		}
		session.release();
	});
}

export function initializeAPIRequest(req: ExpressRequest, res: ExpressResponse<any>): void {
	integrateResponseFunctions(res);
	if(!req.body) {
		res.respondFail("W-1");
	}
	try {
		req.body = JSON.parse(req.body);
	} catch(e) {
		res.respondException(e, "W-2");
	}
}

export function integrateResponseFunctions(res: ExpressResponse<any>): void {
	const resConst = res;
	// Run when a request fails.
	res.respondFail = (errorCode: string, msg=null) => {
		if(resConst.responded) return;
		resConst.responded = true;

		resConst.status(400);
		resConst.setHeader('Content-Type', 'application/json');
		if(msg) {
			resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode, data:{msg: msg}}));
		} else {
			resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode}));
		}
	}
	// Runs when a user needs to login to access the specified page.
	res.respondRequireLogin = () => {
		if(resConst.responded) return;
		resConst.responded = true;

		resConst.status(400);
		resConst.setHeader('Content-Type', 'application/json');
		resConst.end(JSON.stringify({success: false, needLogin: true}));
	}
	// Run when an exception occurs.
	res.respondException = (exception, errorCode) => {
		if(resConst.responded) return;
		resConst.responded = true;

		console.log(exception);
		resConst.status(500);
		resConst.setHeader('Content-Type', 'application/json');
		resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode}));
	}
	// Run when a request succeeds. Can optionally send data back
	res.respondSuccess = (data?: any) => {
		if(resConst.responded) return;
		resConst.responded = true;

		if(data) {
			resConst.status(200);
			resConst.setHeader('Content-Type', 'application/json');
			resConst.end(JSON.stringify({success: true, data: data}));
			return;
		} else {
			resConst.status(200);
			resConst.setHeader('Content-Type', 'application/json');
			resConst.end(JSON.stringify({success: true}));
		}
	}

}
