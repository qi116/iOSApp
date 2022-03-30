
export interface ExpressRequest {
	body: any;
	session: {
		set(key: string, value: any): void;
		save(): void;
		get(key: string): any;
	}
}

export interface ExpressResponse<T> {
	respondFail(errorCode: string, data?: any): void;
	respondRequireLogin(): void;
	respondSuccess(data?: T): void;
	respondException(error: any, errorCode: string): void;

    status(code: number): void;
    setHeader(key: string, val: string): void;
    end(data: T): void;

    responded: boolean;
}
