exports.handler = async (event) => {
  console.log('S3 Event received:', JSON.stringify(event, null, 2));
  
  const bucket = event.Records[0].s3.bucket.name;
  const key = event.Records[0].s3.object.key;
  
  console.log(`File uploaded: ${key} to bucket: ${bucket}`);
  
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'File processed successfully',
      bucket: bucket,
      key: key
    })
  };
};