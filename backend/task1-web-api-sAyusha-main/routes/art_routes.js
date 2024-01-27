const express = require('express');
const router = express.Router();
const artController = require('../controllers/art_controller');

const upload = require('../middlewares/uploads');

router.post("/uploadArtPicture", upload, artController.uploadArtPicture);

router
  .route("/")
  .get(artController.getAllArts)
  .post(artController.createArtPost)
  .put((req, res) => res.status(405).json({ error: "Method not allowed" }))
  .delete(artController.deleteAllArtPosts);


// router.get("/getAllArts", artController.getAllArtPosts);
// router.post("/createArt", artController.createArtPost);
// router.delete("/deleteAllArts", artController.deleteAllArtPosts);

// get arts uploaded by current user
router.get("/myArts", artController.getArtsUploadedByCurrentUser);

// get art uploaded by other users
router.get("/others", artController.getArtsUploadedByOtherUsers);

// search art
router.get("/search", artController.searchArts);

// save art of liking
router.post("/save/:art_id", artController.saveArtPost);
// Remove bookmark from a art
router.delete("/save/:art_id", artController.removeSavedArtPost);
//get all saved arts
router.get("/savedArts", artController.getAllSavedArts);

// alert yourself for upcoming arts
router.post("/alert/:art_id", artController.alertArtPost);
// Remove alert from user profile
router.delete("/alert/:art_id", artController.removeAlertedArtPost);
//get all alerted arts
router.get("/alertArts", artController.getAllAlertedArts);

// get, update and delete art by id
router.route("/:art_id")
    .get(artController.getArtById)
    .put(artController.updateArtById)
    .delete(artController.deleteArtById);


// get users with most arts sorted in descending order
router.get("/users", artController.getAllUsers);

module.exports = router;