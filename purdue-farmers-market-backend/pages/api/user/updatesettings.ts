import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlUpdateStmt} from './../../../components/database';

var mysqlStmtUpdateSettings: MysqlUpdateStmt = new MysqlUpdateStmt()
	.setTable(Table.Users)
	.addCondition("user_id = ?");

interface RequestVendorUpdateSettingsBody {
    email_address: string | null;
    name: string | null;
    profile_picture: string | null;
    phone_number: string | null;
}

var validFields = [
    "email_address",
	"name",
    "profile_picture",
    "phone_number",
];

// Will return success if the settings are successfully updated

export default wrapper.createHandlerWithSession(
    async (body: RequestVendorUpdateSettingsBody, res: ExpressResponse<null>, session: MysqlSession, user: User) => {

        var fields: Array<string> = [];
        var values: Array<string | number> = [];
        for(var i = 0; i < validFields.length; i++) {
			var field: string = validFields[i];
            if(body[field] || body[field] == 0) {
                fields.push(field);
                values.push(body[field]);
            }
        }

		if(fields.length == 0) {
			res.respondFail("UUS-1");
			return;
		}

		values.push(user.user_id);

        await mysqlStmtUpdateSettings
            .setFields(fields)
            .compileQuery()
            .execute(session, values)
            .then((_) => {
                res.respondSuccess();
            })
            .catch((e) => {
                res.respondException(e, "UUS-2");
            });
    }
);
