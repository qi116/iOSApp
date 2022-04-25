import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlUpdateStmt} from './../../../components/database';

var mysqlStmtUpdateSettings: MysqlUpdateStmt = new MysqlUpdateStmt()
	.setTable(Table.Goods)
	.addCondition("good_id = ?");

interface RequestGoodUpdateSettingsBody {
  good_id: number;
  description: string;
  name: string;
  stock: number;
  picture: any;
  good_type: number;
}

var validFields = [
  "description",
  "name",
  "stock",
  "picture",
  "good_type",
];

// Will return success if the settings are successfully updated

export default wrapper.createHandlerWithSession(
    async (body: RequestGoodUpdateSettingsBody, res: ExpressResponse<null>, session: MysqlSession, user: User) => {

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
			res.respondFail("UG-1");
			return;
		}

		values.push(body.good_id);

        await mysqlStmtUpdateSettings
            .setFields(fields)
            .compileQuery()
            .execute(session, values)
            .then((_) => {
                res.respondSuccess();
            })
            .catch((e) => {
                res.respondException(e, "UG-2");
            });
    }
);
