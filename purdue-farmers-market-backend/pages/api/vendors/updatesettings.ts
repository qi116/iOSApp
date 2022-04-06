import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt, MysqlInsertStmt} from './../../../components/database';

var mysqlStmtCheckExists: MysqlStmt = new MysqlSelectStmt()
	.setTable(Table.Vendors)
    .addCondition("vendor_id = ?")
    .compileQuery();

var mysqlStmtUpdateSettings: MysqlInsertStmt = new MysqlInsertStmt()
	.setTable(Table.Vendors)
    .setUpdateOnDuplicateKey(true);

interface RequestVendorUpdateSettingsBody {
    vendor_id: number;

    description: string | null;
    name: string | null;
    background_picture: string | null;
    longitude: number | null;
    latitude: number | null;
}

var validFields = [
    "description",
    "name",
    "background",
    "longitude",
    "latitude"
];

// Will return success if the settings are successfully updated

export default wrapper.createHandlerWithSession(
    async (body: RequestVendorUpdateSettingsBody, res: ExpressResponse<null>, session: MysqlSession, _: User) => {

        if(!body.vendor_id && body.vendor_id != 0) {
            res.respondFail("VUS-1");
            return;
        }
        var fields: Array<string> = [];
        var values: Array<string | number> = [];
        for(var field in validFields) {
            if(body[field] || body[field] == 0) {
                fields.push(field);
                values.push(body[field]);
            }
        }
        await mysqlStmtCheckExists.execute(session, [body.vendor_id])
        .then(async (res) => {
            if(res.length == 0) {
                res.respondFail("VUS-2");
                return;
            }

            fields.unshift("vendor_id");
            values.unshift(body.vendor_id);
            await mysqlStmtUpdateSettings
                .setFields(fields)
                .compileQuery()
                .execute(session, values)
                .then((res) => {
                    res.respondSuccess();
                })
                .catch((e) => {
                    res.respondException(e, "VUS-3");
                });
        }).catch((e) => {
            res.respondException(e, "VUS-4");
        })
    }
);
