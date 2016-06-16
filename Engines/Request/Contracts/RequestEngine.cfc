interface displayname="RequestEngine" {
 
    /**
    * Set up the request engine
    */
    public void function beforeAll();

    /**
    * Clean up the request engine
    */
    public void function afterAll();

    /**
    * Returns the framework route portion of a url.
    *
    * @url A full url
    *
    * @return string
    */
    public string function parseFrameworkRoute(required string url);

    /**
    * Make a request
    *
    * @method The HTTP method to use for the request.
    * @route Optional. The route to execute. Default: ''.
    * @event Optional. The event to execute. Default: ''.
    * @parameters Optional. A struct of parameters to submit with the request. Default: {}.
    *
    * @throws TestBox.AssertionFailed
    * @returns framework event (if any)
    */
    public any function makeRequest(required string method, string event, string route, struct parameters);

}