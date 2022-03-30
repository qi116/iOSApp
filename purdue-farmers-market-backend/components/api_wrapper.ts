import {ExpressRequest, ExpressResponse} from "./typescript_types";

/*
 * Used to create API endpoint functions.
 * Converts request bodies into json objects and
 */
export function createHandler(callback: (body: any, res: ExpressResponse<any>) => void): (req: ExpressRequest, res: ExpressResponse<any>) => void {
	return (req: ExpressRequest, res: ExpressResponse<any>) => {
		initializeAPIRequest(req, res);
		callback(req.body, res);
	}
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
	res.respondRequireLogin = () => {
		if(resConst.responded) return;
		resConst.responded = true;

		resConst.status(400);
		resConst.setHeader('Content-Type', 'application/json');
		resConst.end(JSON.stringify({success: false, needLogin: true}));
	}
	// Run when an exception occurs. Seperate from normal fail to allow reconciliation
	res.respondException = (exception, errorCode) => {
		if(resConst.responded) return;
		resConst.responded = true;

		console.log(exception);
		resConst.status(500);
		resConst.setHeader('Content-Type', 'application/json');
		resConst.end(JSON.stringify({success: false, needLogin: false, errorCode: errorCode}));
	}
	// Run when a request fails. Allows you to send back data to client.
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
