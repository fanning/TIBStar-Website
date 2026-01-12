/**
 * Netlify Edge Function to proxy RAG API requests from chatcan.com
 * Supports both /search and /stats endpoints for MCP compatibility
 */

const RAG_API_URL = process.env.RAG_API_URL || 'http://44.219.6.212:8081';
const RAG_API_KEY = process.env.RAG_API_KEY;

exports.handler = async (event, context) => {
  // Only allow POST and GET
  if (!['GET', 'POST'].includes(event.httpMethod)) {
    return {
      statusCode: 405,
      body: JSON.stringify({ error: 'Method not allowed' })
    };
  }

  try {
    // Determine which endpoint to call
    const params = event.queryStringParameters || {};
    const isStats = params.endpoint === 'stats';

    let targetUrl;
    let fetchOptions = {
      headers: {
        'X-API-Key': RAG_API_KEY,
        'Content-Type': 'application/json'
      }
    };

    if (isStats) {
      // Stats endpoint
      targetUrl = `${RAG_API_URL}/api/stats`;
      fetchOptions.method = 'GET';
    } else {
      // Search endpoint
      const { query, n_results = 10, role_filter } = event.httpMethod === 'GET'
        ? params
        : JSON.parse(event.body || '{}');

      if (!query) {
        return {
          statusCode: 400,
          body: JSON.stringify({ error: 'Query parameter required' })
        };
      }

      // Build query params
      const searchParams = new URLSearchParams({
        query,
        n_results: n_results.toString()
      });
      if (role_filter) {
        searchParams.append('role_filter', role_filter);
      }

      targetUrl = `${RAG_API_URL}/api/search?${searchParams}`;
      fetchOptions.method = 'GET';
    }

    // Forward request to RAG API with API key
    const response = await fetch(targetUrl, fetchOptions);
    const data = await response.json();

    return {
      statusCode: response.status,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST',
        'Access-Control-Allow-Headers': 'Content-Type'
      },
      body: JSON.stringify(data)
    };

  } catch (error) {
    console.error('RAG proxy error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: 'Internal server error',
        message: error.message
      })
    };
  }
};
