import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse} from './../../../components/typescript_types';

import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt} from './../../../components/database';

var mysqlGetVendorInfo: MysqlStmt = new MysqlSelectStmt()
    .setTable(Table.Goods)
    .setFields([
        "goods.good_id",
        "goods.vendor_id",
        "goods.name",
        "goods.description",
        "goods.stock",
        "goods.picture",
        "goods.good_type"
    ])
    .addCondition("good_id = ?")
    .compileQuery();

// No expected request/response data outside of session code.
// Will return success if the user is logged in (i.e. if body.session_full_code is valid)

interface RequestGetGoodInfoBody {
    good_id: number;
}

interface Good {
    name: string;
    vendor_id: number;
    description: string;
    picture: any;
    stock: number;
    good_type: number;
}

export default wrapper.createHandlerWithMysql(
    async (body: RequestGetGoodInfoBody, res: ExpressResponse<Good>, session: MysqlSession) => {
        if(!body.good_id && body.good_id != 0) {
            res.respondFail("GGI-1");
            return;
        }
        await mysqlGetVendorInfo.execute(session, [body.good_id])
            .then((results: Array<Good>) => {
                if(results.length != 1) {
                    res.respondFail("GGI-2");
                    return;
                }
                var result: Good = results[0];
                res.respondSuccess(result);
            })
            .catch((e: any) => {
                res.respondException(e, "GGI-3");
            });
    }
);
