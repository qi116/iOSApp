import * as wrapper from "./../../../components/api_wrapper";

import {ExpressResponse} from './../../../components/typescript_types';

// No expected request/response data outside of session code.
// Will return success if the user is logged in (i.e. if body.session_full_code is valid)

export default wrapper.createHandlerWithSession(
    async (_, res: ExpressResponse<null>) => {
        res.respondSuccess();
    }
);
