const mongoose = require("mongoose");
const Art = require("./art");

const userSchema = mongoose.Schema({
    profileImage: {
        type: String,
        // default: null,
    },
    fullname: {
        type: String,
        required: true,
        trim: true,
    },
    username: {
        type: String,
        required: true,
        unique: true,
        minLength: 6,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    phone: {
        type: String,
        required: true,
        unique: true,
        minLength: 10,
        trim: true,
    },
    password: {
        type: String,
        required: true,
        minlength: 6,
        trim: true,
    },
    bio: {
        type: String,
        // default: " ",
    },
    savedArts: [
        {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Art'
        }
    ],
    collectedArt: [
        {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Art'
        }
    ],
    alerts: [
        {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Art'
        }
    ],
    followingArtists: [
        {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'User'
        }
    ],
    followers: [
        {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'User'
        }
    ],
    bidStatus: {
        type: String,
        enum: ['Pending', 'Winner', 'Loser'],
        default: 'Pending',
    },

    bidAmount: {
        type: Number,
        default: 0
    },
});


// Middleware to update the 'followingCount' field whenever a user follows or unfollows an artist
userSchema.pre("save", async function (next) {
    // Calculate the number of artists the user follows
    this.followingCount = this.followingArtists.length;

    next();
});


// set toJson method to not return hashed password
userSchema.set("toJSON", {
    transform: (document, returnedDocument) => {
        returnedDocument.id = document._id.toString();
        delete returnedDocument._id;
        delete returnedDocument.password;
        delete returnedDocument.__v;
    },
});

module.exports = mongoose.model("User", userSchema);
