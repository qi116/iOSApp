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

var mysqlStmtCreateVendor: MysqlStmt = new MysqlInsertStmt()
	.setTable(Table.Vendors)
	.setFields([
		"owner_user_id",
        "description",
        "longitude",
        "latitude",
		"slogan"
	])
	.compileQuery();

interface SignupRequestBody {
    email_address: string;
    name: string;
    password: string;
    user_type: "user" | "vendor";
}

export interface MysqlResult {
	insertId?: number;
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
                    .then(async (result: MysqlResult) => {
						if(body.user_type == "vendor") {
			                await mysqlStmtCreateVendor.execute(session, [
								result.insertId, // owner_user_id
							    "To be filled in by the vendor.", // description
							    0.0, // Longitude
						        0.0, // Latitude
								"To be filled in by the vendor." // Slogan
							])
			                    .then((_) => {
			                        res.respondSuccess();
			                    }).catch((e) => {
									res.respondException(e, "SU-5");
			                    });
						} else {
	                        res.respondSuccess();
						}
                    }).catch((e) => {
                        res.respondException(e, "SU-3");
                    });
            })
            .catch((e) => {
                res.respondException(e, "SU-4");
            })
    }
);
