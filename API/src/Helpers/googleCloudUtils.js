const { Storage } = require('@google-cloud/storage');

async function getSignedUrl(lessonFileName){
    const storage = new Storage({
        keyFilename: 'src/Config/superb-cubist-399908-453a1e0fb313.json',
      });
      
const bucketName = 'oxford-study-control-app';
const fileName = lessonFileName;

const options = {
  version: 'v4',
  action: 'read',
  expires: Date.now() + 15 * 60 * 1000, // 15 minutes
};

const [url] = await storage.bucket(bucketName).file(fileName).getSignedUrl(options);

return url;
}

module.exports = {
    getSignedUrl
}