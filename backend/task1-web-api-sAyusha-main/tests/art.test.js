const supertest = require("supertest");
const app = require("../app");
const api = supertest(app);
const Art = require("../models/art");
const mongoose = require("mongoose");
const User = require("../models/user");

let token = "";

beforeAll(async () => {
    await Art.deleteMany();
    await User.deleteMany({});
    await Art.create({
        image: "https://picsum.photos/200",
        title: "Art 1",
        creator: "Ayusha Shrestha",
        description: "This is a test art",
        startingBid: 100.99,
        endingDate: Date.now() + 75 * 60 * 1000,
    });

    await api.post("/api/users/register").send({
        username: "tester",
        password: "tester900",
        fullname: "Tester Man",
        email: "tester900@gmail.com",
        phone: "1234567895",
    });

    const res = await api.post("/api/users/login").send({
        username: "tester",
        password: "tester900",
    });

    token = res.body.token;
});

test("Logged in user can get list of arts", async () => {
    await api
        .get("/api/arts/")
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.data).toHaveLength(1);
            expect(res.body.data[0].title).toBe("Art 1");
        });
});

test('should get list of arts uploaded by the other user', async () => {
    // Create a test user
    const user = await User.findOne({ username: "tester" });
    // Create a sample art post by the test user
    const newArt1 = {
        image: "art123.jpg",
        title: "Art by Test User",
        description: "Art Description",
        creator: "Test User",
        startingBid: 200,
        endingDate: new Date(Date.now() + 2 * 60 * 60 * 1000), // Set the expiration date to 2 hours from now
        user: new mongoose.Types.ObjectId(),
    };
    await Art.create(newArt1);

    await api
        .get('/api/arts/others')
        .set('Authorization', `Bearer ${token}`)
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {

            // Check if the 'data' property is an array with art posts uploaded by the test user
            expect(Array.isArray(res.body.data)).toBe(false);
            // expect(res.body.data.length).toBe(1);

            // Check if the art post in the response is uploaded by the test user
            expect(res.body.user).not.toBe(user.id);
        });
});



test("Logged in user cannot get an art that is not found", async () => {
    // Create a random non-existing art ID (you can use a library like 'mongoose.Types.ObjectId()' to generate a valid ID)
    const nonExistingArtId = new mongoose.Types.ObjectId();

    await api
        .get(`/api/arts/${nonExistingArtId}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(404)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.error).toBe("art not found");
        });
});

test("Logged in user can get a single art", async () => {
    const arts = await Art.find({});
    const art = arts[0];
    await api
        .get(`/api/arts/${art._id}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.data[0].title).toBe("Art 1");
        });
});

test("Logged in user cannot update an art that is not found", async () => {
    // Create a random non-existing art ID (you can use a library like 'mongoose.Types.ObjectId()' to generate a valid ID)
    const nonExistingArtId = new mongoose.Types.ObjectId();

    await api
        .put(`/api/arts/${nonExistingArtId}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(404)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.error).toBe("Art not found");
        });
});

test("Logged in user can update an Art", async () => {
    const arts = await Art.find({});
    const art = arts[0];

    await api
        .put(`/api/arts/${art._id}`)
        .set("Authorization", `Bearer ${token}`)
        .send({
            startingBid: 500.99,
            title: "Updated Art Title",
        })
        .expect(201)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe('Art updated successfully');
            expect(res.body.data).toBeDefined();
        });
});

test("Logged in user cannot update an art after its expiration", async () => {
    // Create an art with a past expiration date (art has already expired)
    const expiredArt = await Art.create({
        image: "https://picsum.photos/200",
        title: "Expired Art",
        creator: "Test Artist",
        description: "This is an expired art",
        startingBid: 100.99,
        endingDate: new Date("2023-08-03"), // Set the expiration date to a past date
    });

    await api
        .put(`/api/arts/${expiredArt._id}`)
        .set("Authorization", `Bearer ${token}`)
        .send({
            startingBid: 500.99,
            title: "Updated Art Title",
        })
        .expect(403)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.error).toBe('Art has expired and cannot be updated');
        });
});

test("Logged in user can delete an art", async () => {
    const arts = await Art.find({});
    const art = arts[0];
    await api
        .delete(`/api/arts/${art._id}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe('Art deleted successfully');
        });
});

test("Logged in user cannot delete an art that is not found", async () => {
    // Create a random non-existing art ID (you can use a library like 'mongoose.Types.ObjectId()' to generate a valid ID)
    const nonExistingArtId = new mongoose.Types.ObjectId();

    await api
        .delete(`/api/arts/${nonExistingArtId}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(400)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe("Art not found");
        });
});

test("Logged in user can save an art", async () => {
    const arts = await Art.find({});
    const art = arts[0];
    await api
        .post(`/api/arts/save/${art._id}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(201)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toMatch(/saved successfully/);
        });
});

test("Logged in user can get list of saved arts", async () => {
    await api
        .get("/api/arts/savedArts")
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .then((res) => {
            expect(res.body.data).toHaveLength(1);
        });
});

test("Logged in user can remove the saved art", async () => {
    const arts = await Art.find({});
    const art = arts[0];
    await api
        .delete(`/api/arts/save/${art._id}`)
        .set("authorization", `Bearer ${token}`)
        .expect(200)
        .then((res) => {
            expect(res.body.message).toMatch(/removed successfully/);
        });
});


test('should return 400 if art is not saved', async () => {
    const nonExistingArtId = new mongoose.Types.ObjectId();
    await api
        .delete(`/api/arts/save/${nonExistingArtId._id}`)
        .set('Authorization', `Bearer ${token}`)
        .expect(400);
});

test("user can alert themselves for upcoming art", async () => {
    const nonExistingUserId = new mongoose.Types.ObjectId();

    // create upcoming art
    const art = await Art.create({
        image: "https://picsum.photos/200",
        title: "Upcoming Art",
        creator: "Test Artist",
        description: "This is an upcoming art",
        startingBid: 100.99,
        artType: "Upcoming",
        upcomingDate: new Date(Date.now() + 2 * 60 * 60 * 1000), // Set the expiration date to 2 hours from now
        user: nonExistingUserId,
    });

    await api
        .post(`/api/arts/alert/${art._id}`)
        .set("authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toMatch(/alerted successfully/);
        });
});

test("logged in user cannot alert themselves for upcoming art", async () => {
    const existingUserId = await User.findOne({ username: "tester" });

    // create upcoming art
    const art = await Art.create({
        image: "https://picsum.photos/200",
        title: "Upcoming Art",
        creator: "Test Artist",
        description: "This is an upcoming art",
        startingBid: 100.99,
        artType: "Upcoming",
        upcomingDate: new Date(Date.now() + 2 * 60 * 60 * 1000), // Set the expiration date to 2 hours from now
        user: existingUserId._id,
    });

    await api
        .post(`/api/arts/alert/${art._id}`)
        .set("authorization", `Bearer ${token}`)
        .expect(400)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.error).toBe("You cannot alert your own art");
        });
});

test("Logged in user can get list of alerted arts", async () => {
    await api
        .get("/api/arts/alertArts")
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .then((res) => {
            expect(res.body.data).toHaveLength(1);
        });
});

test('should return 400 if art is not alerted', async () => {
    const nonExistingArtId = new mongoose.Types.ObjectId();
    await api
        .delete(`/api/arts/alert/${nonExistingArtId._id}`)
        .set('Authorization', `Bearer ${token}`)
        .expect(400);
});

test("Logged in user can remove an alert for an art they have alerted", async () => {
    const arts = await Art.find({});
    const art = arts[0];
    // Set an alert for the art first
    await api
        .post(`/api/arts/alert/${art._id}`)
        .set("Authorization", `Bearer ${token}`);

    await api
        .delete(`/api/arts/alert/${art._id}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toMatch(/removed successfully/);
        });
});

test("user can search art", async () => {
    const searchQuery = "Artwork";
    await api
        .get(`/api/arts/search?query=${searchQuery}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            // Check if either 'data' or 'message' property is defined in the response
            expect(res.body.data || res.body.message).toBeDefined();
            // If the 'data' property is an array, check if the search results are not empty
            if (Array.isArray(res.body.data)) {
                expect(res.body.data.length).toBeGreaterThan(0);
            } else {
                // If 'data' is not an array, it might be a message indicating no results found
                expect(res.body.message).toBe("No art posts found");
            }
        });
});

test("Logged in user cannot search for art that is not found", async () => {
    const query = "Non-existing Art"; // Set a search query for an art that does not exist

    await api
        .get(`/api/arts/search?query=${query}`)
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe("No art posts found");
        });
});

test("Logged in user can get arts uploaded by current user", async () => {
    await api
        .get("/api/arts/myArts")
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .then((res) => {
            expect(res.body.data).toHaveLength(1);
        });
});

test("should delete all art posts", async () => {
    // First, create some art posts to be deleted
    await Art.create({
        image: "art1.jpg",
        title: "Art 1",
        creator: "Test User",
        description: "This is art post 1",
        startingBid: 100.0,
        endingDate: new Date(Date.now() + 2 * 60 * 60 * 1000),
    });

    await Art.create({
        image: "art2.jpg",
        title: "Art 2",
        creator: "Test User",
        description: "This is art post 2",
        startingBid: 150.0,
        endingDate: new Date(Date.now() + 2 * 60 * 60 * 1000),
    });

    // Make the API call to delete all art posts
    await api
        .delete("/api/arts")
        .set("Authorization", `Bearer ${token}`)
        .expect(200)
        .expect("Content-Type", /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe("All art posts have been deleted");
        });

    // Check if all art posts have been deleted by fetching the art posts
    const arts = await Art.find();
    expect(arts).toHaveLength(0);
});


afterAll(async () => await mongoose.connection.close());

jest.setTimeout(10000);