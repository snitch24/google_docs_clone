const express = require("express");
const auth = require("../middleware/auth");
const Document = require("../models/document");

const documentRouter = express.Router();

documentRouter.post("/docs/create", auth, async (request, response) => {
    try{
        const {createdAt} = request.body;
        let document = new Document({
          uid: request.user,
          title: "Untitled Document",
          createdAt,
        });

        document = await document.save();
        response.json(document);
    }catch(e){
        response.status(500).json({error:e.message});
    }
});

documentRouter.get("/docs/me", auth, async(req,res)=>{
    try {
        let documents = await Document.find({uid:req.user})
        res.json(documents);
    } catch (e) {
        res.status(500).json({error:e.message()});   
    }
});
module.exports = documentRouter;