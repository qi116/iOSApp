import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlSelectStmt} from './../../../components/database';

var mysqlGetVendors: MysqlStmt = new MysqlSelectStmt()
  .setTable(Table.Vendors)
  .joinTable(Table.Users, "Vendors.owner_user_id = Users.user_id")
  .setFields(["vendor_id","slogan","name","profile_picture","longitude","latitude"]).addCondition("1 = 1")
  .addCondition("Users.name LIKE CONCAT(?,'%')")
	.compileQuery();

interface VendorInfo {
  vendor_id: number;
  slogan: string;
  name: string;
  profile_picture: any;
  longitude: number;
  latitude: number;
}

interface GetVendorsRequestBody {
  search_name: string | null;
}
// No expected request/response data outside of session code.
// Will return success if the user is successfully signed out

export default wrapper.createHandlerWithMysql(
    async (body: GetVendorsRequestBody, res: ExpressResponse<Array<VendorInfo>>, session: MysqlSession) => {
      if (!body.search_name) {
        body.search_name = "";
      }
        await mysqlGetVendors.execute(session, [body.search_name])
            .then(async (results:Array<VendorInfo>) => {
                res.respondSuccess(results);
            })
            .catch((e) => {
                res.respondException(e, "GV-1");
            })
    }
);
