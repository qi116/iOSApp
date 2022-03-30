import Head from 'next/head'

import React from 'react'

export default class Home extends React.Component {

    state = {
        api_page: "",
        form_data: "",
        response: {},
    }

    api_fetch(api_page: string, body: string, callback: (res: any) => void): void {
        try {
            fetch("/api/"+api_page, {
        		method: "POST",
        		headers: {"Content-Type": "application/json"},
        		body: JSON.stringify(body),
        	})
        	.then((response) => {
                console.log(response);
        		return response.json();
        	})
        	.then((res) => {
                console.log(res);
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
        return (
          <div>
            <Head>
              <title>Purdue Farmers Market API</title>
              <meta name="description" content="None" />
              <link rel="icon" href="/favicon.ico" />
            </Head>

            <main>
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
