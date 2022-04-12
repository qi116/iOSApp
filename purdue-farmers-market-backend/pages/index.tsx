import Head from 'next/head'

import React from 'react'

export default class Home extends React.Component {

    state = {
        email: "test",
        password: "test",
        api_page: "",
        form_data: "",
        response: {},
        session_full_code: "",
    }

    api_fetch(api_page: string, body: string, callback: (res: any) => void): void {
        try {
            if(this.state.session_full_code) {
                body = body.substring(0, body.length-1) + (body.length != 2 ? "," : "") + '"session_full_code": "' + this.state.session_full_code + '"}';
            }
            fetch("/api/" + api_page, {
        		method: "POST",
        		headers: {"Content-Type": "application/json"},
        		body: body,
        	})
        	.then((response) => {
        		return response.json();
        	})
        	.then((res) => {
        		if(!res) {
        			callback({"success":false, "loginNeeded":false, "errorCode":"AF-1"});
        			return;
        		}
        		if(res.success) {
        			callback(res);
        			return;
        		}
        		if(res.needLogin) {
        			callback({"success":false, "loginNeeded":true,"errorCode":"AF-2"});
        			return;
        		}
        		callback(res);
        	}).catch(e => {
        		console.log(e);
        		callback({"success":false, "loginNeeded":false, "errorCode":"AF-4"});
        	});
        } catch(e) {
            callback({"success":false, "loginNeeded":false, "errorCode":"AF-5"});
        }
    }

    handleSubmit(page: Home) {
        return (event: any) => {

            page.api_fetch(page.state.api_page, page.state.form_data, (response: any) => {
                page.setState({response: response});
            });
            event.preventDefault();
        }
    }

    render() {
        var page = this;
        return (
          <div>
            <Head>
              <title>Purdue Farmers Market API</title>
              <meta name="description" content="None" />
              <link rel="icon" href="/favicon.ico" />
            </Head>

            <main>
                <label>
                    Email Address
                    <br />
                    <input type="text" value={this.state.email} onChange={(elem) => {
                        this.setState({email: elem.target.value})
                    }} />
                </label>
                <br/>
                <label>
                    Password
                    <br />
                    <input type="text" value={this.state.password} onChange={(elem) => {
                        this.setState({password: elem.target.value})
                    }} />
                </label>
                <br/>
                <button onClick={() => {
                    this.api_fetch("user/login", JSON.stringify({email_address: this.state.email, password: this.state.password}), (response: any) => {
                        if(response.success)
                            page.setState({session_full_code: response.data.session_full_code});
                        else
                            page.setState({session_full_code: "Error. " + response.errorCode})
                    });
                }}>Login</button>
                <br/>
                <p>{this.state.session_full_code}</p>
                <br/>
                <button onClick={() => {
                    this.api_fetch("user/logout", JSON.stringify({session_full_code: this.state.session_full_code}), (response: any) => {
                        if(response.success)
                            page.setState({session_full_code: "Logged Out"});
                        else
                            page.setState({session_full_code: "Error. " + response.errorCode})
                    });
                }}>Logout</button>
                <br/>
                <form onSubmit={this.handleSubmit(this)}>
                    <label>
                        API Page:
                        <br />
                        <input type="text" value={this.state.api_page} onChange={(elem) => {
                            this.setState({api_page: elem.target.value})
                        }} />
                    </label>
                    <br />
                    <label>
                        Form Data:
                    </label>
                    <br />
                    <textarea value={this.state.form_data} onChange={(elem) => {
                        this.setState({form_data: elem.target.value})
                    }} />
                    <br />
                    <input type="submit" value="Submit" />
                </form>
                <p>
                    {JSON.stringify(this.state.response)}
                </p>
            </main>
          </div>
        )
    }

}
