import * as wrapper from "./../../../components/api_wrapper";
import * as bcrypt from 'bcrypt';

import {ExpressResponse} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt, MysqlInsertStmt} from './../../../components/database';

var mysqlStmtFindUser: MysqlStmt = new MysqlSelectStmt()
	.setTable(Table.Users)
	.setFields(["users.user_id"])
	.addCondition("users.email_address = ?")
	.compileQuery();

var mysqlStmtCreateUser: MysqlStmt = new MysqlInsertStmt()
	.setTable(Table.Users)
	.setFields([
		"email_address",
		"name",
        "salted_password",
        "user_type"
	])
	.compileQuery();

interface SignupRequestBody {
    email_address?: string;
    name?: string;
    password?: string;
    user_type?: "user" | "vendor";
}

// No data in the response. Only success boolean

export default wrapper.createHandlerWithMysql(
    async (body: SignupRequestBody, res: ExpressResponse<null>, session: MysqlSession) => {
        if(!body.email_address || !body.name ||
            !body.password ||
            !(body.user_type == "user" || body.user_type == "vendor")) {

            // Invalid form data.
            res.respondFail("SU-1");
            return;
        }
        // Search for duplicates
        await mysqlStmtFindUser.execute(session, [body.email_address])
            .then(async (results: Array<any>) => {
                if(results.length != 0) {
                    // Duplicate email address found
                    res.respondFail("SU-2");
                    return;
                }

                var salted_password = await bcrypt.hash(body.password, 10);

                await mysqlStmtCreateUser.execute(session, [body.email_address, body.name, salted_password, body.user_type])
                    .then((_) => {
                        res.respondSuccess();
                    }).catch((e) => {
                        res.respondException(e, "SU-3");
                    })
            })
            .catch((e) => {
                res.respondException(e, "SU-4");
            })
    }
);
