const functions = require("firebase-functions");
const {Firestore} = require('@google-cloud/firestore');

/**
 * @req the query object 
 * @res the query response
 * @return user from a mangopay id 
 */

exports.getUsersByMangopayId = functions.https.onRequest(async (req, res) => {
  const collection = new Firestore().collection("user")

  var body = JSON.parse(req.body)

  const mangopayId = body.mangoPayId;

  if(mangopayId == undefined || mangopayId.length == 0) {
    res.status(404).send({
      status: "FAILED",
      error: "mangoPayId must not be null",
    })
    
  } else {
    const selectedFields = body.fields;
    await collection.where("mangoPayId", 'in', mangopayId).get().then((data) => {
      let response = []
      data.docs.forEach((doc) => {
        if(selectedFields != undefined) {
          let item = {};
          for(const field in selectedFields) {
            console.log(`field: ${doc.data()[selectedFields[field]]}`)
            item[selectedFields[field]] = doc.data()[selectedFields[field]];
          }
          response.push(item);
        } else {
          response.push(doc.data());
        }
      })
      res.status(200).send({
        status: "SUCCESS",
        user: response, 
      })
    }).catch((error) => {
      res.status(404).send({
        status: "FAILED",
        error: error.message,
        stacktrace: error.stacktrace,
      })
    });
  }  
})