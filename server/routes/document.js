const express=require("express");
const Document= require("../models/document");
const auth = require("../middlewares/auth");
const documentRouter= express.Router();

documentRouter.post('/doc/create',auth, async(req,res)=>{
    try {
        const{createdAt}=req.body;
        let document= new Document({
            uid:req.user,
            title:"Untitled Document",
            createdAt,
        });

        document= await document.save();
        res.json(document);
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});
module.exports=documentRouter;