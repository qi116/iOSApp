import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlInsertStmt} from './../../../components/database';

var mysqlStmtAddGood: MysqlStmt = new MysqlInsertStmt()
	.setTable(Table.Goods)
	.setFields(["vendor_id", "name", "description", "picture", "stock", "good_type"])
    .compileQuery();

interface RequestAddGoodBody {
    name: string | null;
    description: string | null;
    picture: string | null;
    stock: number | null;
    good_type: number | null;
}

// Will return success if the settings are successfully updated

export default wrapper.createHandlerWithSession(
    async (body: RequestAddGoodBody, res: ExpressResponse<null>, session: MysqlSession, user: User) => {
		if(!user.user_is_vendor || !body.name || !body.description) {
            res.respondFail("AG-1");
            return;
        }

        await mysqlStmtAddGood
            .execute(session, [user.vendor_id, body.name, body.description, body.picture, body.stock, body.good_type])
            .then((_) => {
                res.respondSuccess();
            })
            .catch((e) => {
                res.respondException(e, "AG-2");
            });
    }
);
