// import * as user from "firestore/user.js" 
const functions = require("firebase-functions");
const {Firestore} = require('@google-cloud/firestore');

exports.handleMessage = functions.https.onRequest(async (req, res) => {
  try {

  } catch(error) {
    
  }
})

// const stripe = require("stripe")("sk_test_51J7plnEBJbFZnzalvUng7Yv7K6WkalbZ0ONbww3UpUQJY9qpsi8XWVWp8pWVbPdMTOiYncMcmxFjfqOvvGqjb4rU00AO7ZAUpB");

// exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
//   try {
//     let customerId;

//     const customerList = await stripe.customers.list({
//       email: req.body.email,
//       limit: 1
//     })

//     if(customerList.data.length !== 0) {
//       customerId = customerList.data[0].id;
//     } 
//     else {
//       const customer = await stripe.customers.create({
//         email: req.body.email
//       });
//       customerId = customer.data.id;
//     }

//     const ephemeralKey = await stripe.ephemeralKeys.create(
//       { customer: customerId },
//       { apiVersion: '2020-08-27' }
//     );

//     const paymentIntent = await stripe.paymentIntents.create({
//       amount: parseInt(req.body.amount),
//       currency: 'eur',
//       customer: customerId,
//     });

//     res.status(200).send({
//       paymentIntent: paymentIntent.client_secret,
//       ephemeralKey: ephemeralKey.secret,
//       customer: customerId,
//       success: true,
//     })

//   } catch (error) {
//     res.status(404).send({ success: false, error: error.message, stacktrace: error.stacktrace })
//   }
// });
