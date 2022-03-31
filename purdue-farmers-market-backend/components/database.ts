import * as mysql from 'mysql'

export var mysqlConnectionPool = mysql.createPool({
	host: process.env.MYSQL_HOST,
	user: process.env.MYSQL_USER,
	password: process.env.MYSQL_PSWD,
	port: Number(process.env.MYSQL_PORT),
	database: 'farmers_market_db',
	connectionLimit: 10,
});

console.log("Mysql Created");

export var mysqlGetSession = () => {
	return new Promise<MysqlSession>(function(resolve, reject) {
		mysqlConnectionPool.getConnection(function(err, connection) {
			if(err) {
				reject(err);
				return;
			}
			resolve(connection);
		});
	});
}

export interface MysqlSession {
	query(query: string, bindings: Array<string | number | boolean>, callback: (error: any, results: any, fields: any) => void) : void;
	release(): void;
}

export enum Table {
    Users = "users",
    Vendors = "vendors",
    Goods = "goods",
    Reviews = "reviews",
    Favorites = "favorites",
    Sessions = "sessions",
    messages = "messages"
}

export class MysqlStmt {
    query: string;

    constructor(query: string) {
        this.query = query;
    }

    execute(mysqlSession: MysqlSession, bindings: Array<string | number | boolean>): Promise<any> {
        var sqlStmt = this;
		return new Promise<any>(function(resolve, reject) {
			mysqlSession.query(sqlStmt.query, bindings, function(error, results, _) {
				if(error) {
					reject(error);
					return;
				}
				resolve(results);
			});
		});
	}
}

export class MysqlSelectStmt {

    table: Table;
    fields: Array<string | number | boolean>;
    conditions: Array<string>;
	joinedTables: Array<{
		table: Table,
		linkCondition: string,
	}>;

    constructor() {
        this.conditions = [];
		this.joinedTables = [];
    }

    setTable(table: Table): MysqlSelectStmt {
        this.table = table;
        return this;
    }

    setFields(fields: Array<string | number | boolean>): MysqlSelectStmt {
        this.fields = fields;
        return this;
    }

    addCondition(condition: string): MysqlSelectStmt {
        this.conditions.push(condition);
        return this;
    }

	joinTable(table: Table, linkCondition: string) {
		this.joinedTables.push({
			table: table,
			linkCondition: linkCondition
		});
		return this;
	}

    compileQuery() {
        var query: string =
            "SELECT " + this.fields.join(",") +
            " FROM " + this.table.toString() +
			this.joinedTables.map(joinedTable =>
				" LEFT JOIN " + joinedTable.table + " ON (" + joinedTable.linkCondition + ")"
			).join("") +
            " WHERE " + this.conditions.map(cond => "(" + cond + ")").join(" AND ");
        return new MysqlStmt(query);
    }

}

export class MysqlInsertStmt {
	table: Table;
	fields: Array<string>;
	updateOnDuplicateKey: boolean;

	constructor() {
		this.fields = [];
		this.updateOnDuplicateKey = false;
	}

	setTable(table: Table): MysqlInsertStmt {
		this.table = table;
		return this;
	}
	setFields(fields: Array<string>) : MysqlInsertStmt {
		this.fields = fields;
		return this;
	}

	setUpdateOnDuplicateKey(updateOnDuplicateKey: boolean) : MysqlInsertStmt {
		this.updateOnDuplicateKey = updateOnDuplicateKey;
		return this;
	}

	compileQuery() : MysqlStmt {
		var vals = "?,".repeat(this.fields.length);
		vals = vals.substring(0, vals.length-1);
		return new MysqlStmt(
			"INSERT INTO " + this.table + " (" + this.fields.join(",") + ") VALUES (" + vals + ")"+ (this.updateOnDuplicateKey ? " ON DUPLICATE KEY UPDATE" : "")
		);
	}
}


export class MysqlDeleteStmt {
	table: Table;
	conditions: Array<string>;

	constructor() {
		this.conditions = [];
	}

	setTable(table: Table) : MysqlDeleteStmt {
		this.table = table;
		return this;
	}

	addCondition(condition: string) : MysqlDeleteStmt {
		this.conditions.push(condition);
		return this;
	}

	compileQuery() : MysqlStmt {
		return new MysqlStmt(
			"DELETE FROM " + this.table + " WHERE (" + this.conditions.join(") AND (") + ")"
		);
	}
}
