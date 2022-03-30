import * as wrapper from "./../../components/api_wrapper";
import {ExpressResponse} from './../../components/typescript_types';

interface HelloRequestBody {
    test?: string;
}

interface HelloRequestResponse {
    val: string
}

export default wrapper.createHandler(
    (body: HelloRequestBody, res: ExpressResponse<HelloRequestResponse>) => {
        if(body.test) {
            res.respondSuccess({ val: body.test });
        } else {
            res.respondSuccess({ val: 'John Doe' });
        }
    }
);
