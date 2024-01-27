const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
// const Bid = require("../models/bid")
const path = require("path");
const fs = require("fs");

// register method
const registerUser = (req, res, next) => {
  const { fullname, username, email, phone, password } = req.body;
  User.findOne({ username: username })
    .then((user) => {
      if (user) {
        return res.status(400).json({ error: "duplicate username" });
      }

      if (!username || !password || !fullname || !email) {
        return res.status(400).json({ error: "Please fill in all fields" });
      }

      if (!email.includes("@") || !email.includes(".")) {
        return res.status(400).json({ error: "Please enter a valid email" });
      }

      bcrypt.hash(password, 10, (err, hash) => {
        if (err) {
          res.status(500).json({ error: err.message });
        }
        User.create({ fullname, username, email, phone, password: hash })
          .then((user) => {
            // Setting the profileImage value to null initially
            // user.profileImage = null;
            user.save().then((savedUser) => {
              res.status(201).json(savedUser);
            });
          })
          .catch(next);
      });
    })
    .catch(next);
};


// login method
const loginUser = (req, res, next) => {
  const { username, password } = req.body;
  User.findOne({ username: username })
    .then((user) => {
      if (!username || !password) {
        return res
          .status(400)
          .send({ message: "Please provide an username and password" });
      }
      if (!user) {
        return res.status(400).json({ error: "user is not registered" })
      }
      bcrypt.compare(password, user.password, (err, success) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }
        if (!success) {
          return res.status(400).json({ error: "password does not match" })
        }
        const payload = {
          id: user.id,
          username: user.username,
        }
        jwt.sign(
          payload,
          process.env.SECRET,
          { expiresIn: process.env.JWT_EXPIRE },
          (err, token) => {
            if (err) {
              return res.status(500).json({ error: err.message })
            }
            res.json({ status: "success", token: token });
          }
        );
      });
    })
    .catch(next);
};

// get users
const getAllUsers = async (req, res, next) => {
  const users = await User.find({});
  res.status(200).json({
    data: users,
  });
};

// get current user
const getCurrentUser = async (req, res, next) => {
  const currentUser = req.user;

  res.status(200).json({
    data: currentUser
  });
};

// get user by id
const getUserInfoById = async (req, res, next) => {
  const userId = req.user.id;

  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({ data: [user] });
  } catch (error) {
    next(error);
  }
};

// delete user
const deleteUser = async (req, res, next) => {
  console.log(req.params.user_id);
  User.findByIdAndDelete(req.params.user_id)
    .then((user) => {
      if (user != null) {
        var imagePath = path.join(
          __dirname,
          "../public/uploads/" + user.image
        );
        fs.unlink(imagePath, (err) => {
          if (err) {
            console.log(err);
          }
          res.status(200).json({
            message: "User deleted successfully",
          });
        });
      } else {
        res.status(400).json({
          message: "User not found",
        });
      }
    })
    .catch((err) => {
      res.status(500).json({
        message: err.message,
      });
    });
};


// get user profile
const getUserProfile = async (req, res, next) => {
  try {
    const userId = req.user.id; // Use req.user._id if this holds the user ID
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({
      data: [user],
    });
    console.log("User ID:", userId); // Log the user ID for debugging
  } catch (error) {
    next(error);
  }
};


const updateUserProfile = async (req, res, next) => {
  const userId = req.user.id;
  const { fullname, username, email, phone, bio } = req.body;
  console.log("User ID:", userId); // Log the user ID for debugging

  try {
    const user = await User.findById(userId);
    console.log("User:", user); // Log the user object for debugging

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (fullname && fullname !== "" && fullname !== user.fullname) {
      user.fullname = fullname;
    }
    if (username && username !== "" && username !== user.username) {
      const existingUserWithUsername = await User.findOne({
        username: username,
      });
      if (existingUserWithUsername) {
        return res.status(400).json({ error: "Username is already taken" });
      }
      user.username = username;
    }
    if (email && email !== "" && email !== user.email) {
      const existingUserWithEmail = await User.findOne({ email: email });
      if (existingUserWithEmail) {
        return res.status(400).json({ error: "Email is already taken" });
      }
      user.email = email;
    }
    if (phone !== undefined && phone !== user.phone) {
      const existingUserWithPhone = await User.findOne({
        phone: phone,
      });
      if (existingUserWithPhone) {
        return res.status(400).json({ error: "Phone number is already taken" });
      }
      user.phone = phone;
    }
    if (bio !== undefined && bio !== user.bio) {
      user.bio = bio;
    }

    // Save the updated user
    const updatedUser = await user.save();

    res.json({
      data: [updatedUser]
    });
  } catch (error) {
    console.error("Error updating user profile:", error); // Log any errors for debugging
    next(error);
  }
};

// Upload single image
let uploadedFilename;
const uploadProfilePicture = async (req, res, next) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    if (!req.file) {
      return res.status(400).json({ message: "Please upload a file" });
    }

    // Update the user's profile picture in the database
    const userId = req.user.id;
    const profileImage = req.file.filename;

    User.findByIdAndUpdate(userId, { profileImage })
      .then(() => {
        res.status(200).json({
          data: profileImage,
        });
      })
      .catch((error) => {
        console.log(error);
        res.status(500).json({
          message: "Failed to update the user's profile picture",
        });
      });
  }
  catch (error) {
    next(error);
  }
};


// change password
const updatePassword = async (req, res, next) => {
  const { currentPassword, newPassword, confirmPassword } = req.body;
  const userId = req.user.id;

  try {
    // Find the user by ID
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Compare the current password with the stored hashed password
    const passwordMatch = await bcrypt.compare(currentPassword, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ error: "Incorrect current password" });
    }

    // Check if the new password and confirm password match
    if (newPassword !== confirmPassword) {
      return res
        .status(400)
        .json({ error: "New password and confirm password do not match" });
    }

    // Check if the new password is different from the current password
    if (currentPassword === newPassword) {
      return res.status(400).json({
        error: "New password must be different from the current password",
      });
    }

    // Hash the new password
    const hashedNewPassword = await bcrypt.hash(newPassword, 10);

    // Update the user's password
    user.password = hashedNewPassword;

    // Save the updated user
    await user.save();

    res.status(204).json({ message: "Password updated successfully" });
  } catch (error) {
    next(error);
  }
};

// logout controller
const logoutUser = async (req, res, next) => {
  try {
    req.logout();
    res.json({ status: "success", message: "User logged out" });
  } catch (error) {
    next(error);
  }
};

const getBidStatus = async (req, res, next) => {
  const userId = req.params.user_id;

  try {
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Assuming the bidStatus is a field in the user schema
    const bidStatus = user.bidStatus;

    res.json({ bidStatus });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal server error' });
  }
};

module.exports = {
  registerUser,
  loginUser,
  getAllUsers,
  getCurrentUser,
  getUserInfoById,
  deleteUser,
  getUserProfile,
  updateUserProfile,
  uploadProfilePicture,
  updatePassword,
  logoutUser,
  getBidStatus,
}
