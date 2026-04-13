exports.handler = async (event) => {
  console.log('API Event received:', JSON.stringify(event, null, 2));
  
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      message: 'Hello from AWS Lambda on EKS Hybrid Platform!',
      timestamp: new Date().toISOString(),
      project: process.env.PROJECT_NAME
    })
  };
};