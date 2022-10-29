const express = require("express");
const User = require("../models/user");
const jwt = require("jsonwebtoken");
const auth = require( "../middleware/auth" );
const authRouter = express.Router();

authRouter.post("/api/signup", async (request, response) => {
  try {
    //Separating details from request body received from client

    const { name, email, profilePic } = request.body;

    //Checking if exists or not
    let user = await User.findOne({ email: email });

    //If user does not exists
    if (!user) {
      user = new User({
        name: name,
        email: email,
        profilePic: profilePic,
      });
      //Saving data on MongoDB because [User] is of type mongoose
      user = await user.save();
    }
    const token = jwt.sign({ id: user._id},"passwordKey");

    response.status(200).json({ user: user, token: token });
  } catch (e) {
    //If any error return response with error
    response.status(500).json({ error: e.message });
  }
});

authRouter.get("/", auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({user: user,token : req.token});
});

module.exports = authRouter;
