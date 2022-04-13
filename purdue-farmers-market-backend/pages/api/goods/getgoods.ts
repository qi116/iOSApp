import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt} from './../../../components/database';

var mysqlGetGoods: MysqlSelectStmt = new MysqlSelectStmt()
  .setTable(Table.Vendors)
  .setFields(["vendor_id","good_id","name","description","stock","picture", "good_type"])
  .addCondition("1 = 1")
  .addCondition("name LIKE CONCAT(?,'%')");

interface GoodsInfo {
  good_id: number;
  vendor_id: number;
  description: string;
  name: string;
  stock: number;
  picture: any;
  good_type: number;
}

interface GetGoodsRequestBody {
  search_name: string | null;
  page_number: number | null;
}
// No expected request/response data outside of session code.
// Will return success if the user is successfully signed out

export default wrapper.createHandlerWithMysql(
    async (body: GetGoodsRequestBody, res: ExpressResponse<Array<GoodsInfo>>, session: MysqlSession) => {
      if (!body.search_name) {
        body.search_name = "";
      }
      if (!body.page_number || !Number.isInteger(body.page_number)) {
        body.page_number = 0;
      }
        await mysqlGetGoods.setLimit(20, 20 * body.page_number).compileQuery().execute(session, [body.search_name])
            .then(async (results:Array<GoodsInfo>) => {
                res.respondSuccess(results);
            })
            .catch((e) => {
                res.respondException(e, "GG-1");
            })
    }
);
