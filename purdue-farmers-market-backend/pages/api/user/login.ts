import * as wrapper from "./../../../components/api_wrapper";
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';

import {ExpressResponse} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt, MysqlInsertStmt} from './../../../components/database';

var mysqlStmtFindUser: MysqlStmt = new MysqlSelectStmt()
	.setTable(Table.Users)
	.setFields([
		"users.email_address",
		"users.salted_password",

		"users.user_id",
	])
	.addCondition("users.email_address = ?")
	.compileQuery();

var mysqlStmtCreateSession: MysqlStmt = new MysqlInsertStmt()
	.setTable(Table.Sessions)
	.setFields([
		"user_id",
		"session_code"
	])
	.compileQuery();

interface LoginRequestBody {
    email_address?: string;
    password?: string;
}

interface LoginRequestResponse {
    session_full_code: string
}

export default wrapper.createHandlerWithMysql(
    async (body: LoginRequestBody, res: ExpressResponse<LoginRequestResponse>, session: MysqlSession) => {
        if(!body.email_address || !body.password) {
            // Empty email or password.
            res.respondFail("LI-1");
            return;
        }
        await mysqlStmtFindUser.execute(session, [body.email_address])
            .then(async (results: Array<{
                email_address: string;
                salted_password: string;
                user_id: number;
            }>) => {
                if(results.length == 0) {
                    // Email address not found
                    // Use the same error so that they don't know if its valid
                    res.respondFail("LI-1");
                    return;
                }
                var result = results[0];
                const valid_password = await bcrypt.compare(body.password, result.salted_password);
                if(!valid_password) {
                    // Invalid password
                    res.respondFail("LI-1");
                    return;
                }
		        	var session_code = crypto.randomBytes(16).toString('hex');

		            await mysqlStmtCreateSession.execute(session, [result.user_id, session_code])
		                .then((result) => {
		                    res.respondSuccess({session_full_code: result.insertId + ":" + session_code});
		                }).catch((e) => {
		                    res.respondException(e, "LI-2");
		                })
		        })
		        .catch((e) => {
		            res.respondException(e, "LI-3");
		        })
    }
);
