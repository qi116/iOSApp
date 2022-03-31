
export interface ExpressRequest {
	body: any;
}

export interface ExpressResponse<T> {
	respondFail(errorCode: string, data?: any): void;
	respondRequireLogin(): void;
	respondException(error: any, errorCode: string): void;
	respondSuccess(data?: T): void;

    status(code: number): void;
    setHeader(key: string, val: string): void;
    end(data: T): void;

    responded: boolean;
}

export enum UserType {
	USER = 1,
	VENDOR = 2,
}

export interface User {
	session_id: number;
	user_id: number;
	user_type: UserType;
	name: string;
	user_is_vendor: boolean;
}
