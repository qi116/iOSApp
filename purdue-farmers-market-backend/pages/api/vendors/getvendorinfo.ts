import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse} from './../../../components/typescript_types';

import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt} from './../../../components/database';

var mysqlGetVendorInfo: MysqlStmt = new MysqlSelectStmt()
    .setTable(Table.Vendors)
    .joinTable(Table.Users, "users.user_id = vendors.owner_user_id")
    .setFields([
        "users.name",
        "users.profile_picture",
        "vendors.description",
        "vendors.background_picture",
        "vendors.longitude",
        "vendors.latitude",
        "vendors.slogan"
    ])
    .addCondition("vendor_id = ?")
    .compileQuery();

// No expected request/response data outside of session code.
// Will return success if the user is logged in (i.e. if body.session_full_code is valid)

interface RequestGetVendorInfoBody {
    vendor_id: number;
}

interface Vendor {
    name: string;
    description: string;
    profile_picture: any;
    background_picture: any;
    longitude: number;
    latitude: number;
    slogan: string;
}

export default wrapper.createHandlerWithMysql(
    async (body: RequestGetVendorInfoBody, res: ExpressResponse<Vendor>, session: MysqlSession) => {
        if(!body.vendor_id && body.vendor_id != 0) {
            res.respondFail("GVI-1");
            return;
        }
        await mysqlGetVendorInfo.execute(session, [body.vendor_id])
            .then((results: Array<Vendor>) => {
                if(results.length != 1) {
                    res.respondFail("GVI-2");
                    return;
                }
                var result: Vendor = results[0];
                res.respondSuccess(result);
            })
            .catch((e: any) => {
                res.respondException(e, "GVI-3");
            });
    }
);
