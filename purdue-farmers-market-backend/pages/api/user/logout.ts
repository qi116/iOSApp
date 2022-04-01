import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse, User} from './../../../components/typescript_types';
import {MysqlSession, Table, MysqlStmt, MysqlDeleteStmt} from './../../../components/database';

var mysqlStmtRemoveSession: MysqlStmt = new MysqlDeleteStmt()
	.setTable(Table.Sessions)
	.addCondition("session_id = ?")
	.compileQuery();

// No expected request/response data.
// Will return success if the user is successfully signed out

export default wrapper.createHandlerWithSession(
    async (_, res: ExpressResponse<null>, session: MysqlSession, user: User) => {
        await mysqlStmtRemoveSession.execute(session, [user.session_id])
            .then(async (_) => {
                res.respondSuccess();
            })
            .catch((e) => {
                res.respondException(e, "LO-1");
            })
    }
);
