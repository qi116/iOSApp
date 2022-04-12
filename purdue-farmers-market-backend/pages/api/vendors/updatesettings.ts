import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt, MysqlUpdateStmt} from './../../../components/database';

var mysqlStmtCheckExists: MysqlStmt = new MysqlSelectStmt()
	.setTable(Table.Vendors)
	.setFields(["vendors.vendor_id"])
    .addCondition("vendor_id = ?")
    .compileQuery();

var mysqlStmtUpdateSettings: MysqlUpdateStmt = new MysqlUpdateStmt()
	.setTable(Table.Vendors)
	.addCondition("vendor_id = ?");

interface RequestVendorUpdateSettingsBody {
    description: string | null;
    name: string | null;
    background_picture: string | null;
    longitude: number | null;
    latitude: number | null;
}

var validFields = [
    "description",
	"background_picture",
    "longitude",
    "latitude",
	"slogan"
];

// Will return success if the settings are successfully updated

export default wrapper.createHandlerWithSession(
    async (body: RequestVendorUpdateSettingsBody, res: ExpressResponse<null>, session: MysqlSession, user: User) => {
		if(!user.user_is_vendor) {
            res.respondFail("VUS-1");
            return;
        }
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
			res.respondFail("VUS-2");
			return;
		}
		values.push(user.vendor_id);

        await mysqlStmtCheckExists.execute(session, [user.vendor_id])
        .then(async (results) => {
            if(results.length == 0) {
                res.respondFail("VUS-3");
                return;
            }

            await mysqlStmtUpdateSettings
                .setFields(fields)
                .compileQuery()
                .execute(session, values)
                .then((_) => {
                    res.respondSuccess();
                })
                .catch((e) => {
                    res.respondException(e, "VUS-4");
                });
        }).catch((e) => {
            res.respondException(e, "VUS-5");
        })
    }
);
