const supertest = require('supertest');
const app = require('../app');
const { default: mongoose } = require('mongoose');
const api = supertest(app);
const User = require('../models/user');
const jwt = require('jsonwebtoken');

// initialize a variable to store the valid token
let validToken;

beforeAll(async () => {
  await User.deleteMany({})
});

test('user registration', async () => {
  const res = await api.post('/api/users/register')
    .send({
      fullname: "Test User",
      username: "testUser1",
      email: "test@gmail.com",
      phone: "9865109088",
      password: "test123",
    })
    .expect(201)
  // console.log(res.body)
  expect(res.body.username).toBe("testUser1")
});


// promises ma return and then use garne
test('registration of duplicate username', () => {
  return api.post('/api/users/register')
    .send({
      fullname: "Test User",
      username: "testUser1",
      email: "test@gmail.com",
      phone: "9865109088",
      password: "test123",
    }).expect(400)
    .then((res) => {
      // console.log(res.body)
      expect(res.body.error).toMatch(/duplicate/)
    })
});

test("registration with incomplete fields", async () => {
  const res = await api
    .post("/api/users/register")
    .send({
      username: "testUser 3",
      password: "test123",
      fullname: "Test User",
    })
    .expect(400);
  expect(res.body.error).toMatch(/fill in all fields/);
});



test('registered user can login', async () => {
  const res = await api.post('/api/users/login')
    .send({
      username: "testUser1",
      password: "test123"
    })
    .expect(200)
  // console.log(res.body)
  expect(res.body.token).toBeDefined();
  validToken = res.body.token;
});

test('user login with unregistered username', async () => {
  const res = await api.post('/api/users/login')
    .send({
      username: "jasuux",
      password: "test123"
    })
    .expect(400)
  expect(res.body.error).toMatch(/registered/)
});

test('user login with wrong password', async () => {
  const res = await api.post('/api/users/login')
    .send({
      username: "testUser1",
      password: "jazz12"
    })
    .expect(400)
    .then((res) => {
      expect(res.body.error).toBe("password does not match");
    });
});

test("user login with incomplete fields", async () => {
  const res = await api
    .post("/api/users/login")
    .send({
      username: "testUser1",
    })
    .expect(400);
  expect(res.body.message).toMatch(/provide an username and password/);
});

test('user can get all users', async () => {
  await api
    .get('/api/users/getAllUsers')
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
      expect(Array.isArray(res.body.data)).toBe(true);
    });
});

test('user can get current user', async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;
  await api
    .get('/api/users/getCurrentUser')
    .set('Authorization', `Bearer ${token}`)
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
    });
});

test('user can get user info by id', async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;
  const user = await User.findOne({ username: 'testUser1' });

  await api
    .get(`/api/users/${user._id}`)
    .set('Authorization', `Bearer ${token}`)
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
      expect(Array.isArray(res.body.data)).toBe(true);
    });
});

test('get bid status for a user', async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;
  const user = await User.findOne({ username: 'testUser1' });
  const response = await api
    .get(`/api/users/${user._id}/bidstatus`)
    .set('Authorization', `Bearer ${token}`)
    .expect(200);

  expect(response.body.bidStatus).toBe(user.bidStatus);
});

test('get bid status for a non-existing user', async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;
  const nonExistingUserId = '616e21ea9ac29a1a49a13627'; // A random non-existing user ID
  const response = await api
    .get(`/api/users/${nonExistingUserId}/bidstatus`)
    .set('Authorization', `Bearer ${token}`)
    .expect(404);

  expect(response.body.message).toBe('User not found');
});


test("get user profile", async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;

  const res = await api
    .get("/api/users/")
    .set("Authorization", `Bearer ${token}`)
    .expect(200);

  expect(res.body.data.length).toBe(1);
  expect(res.body.data[0].username).toBe("testUser1");
});

test("upload profile picture", async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;

  const res = await api
    .post("/api/users/uploadProfilePicture")
    .set("Authorization", `Bearer ${token}`)
    .attach("uploadPictures", "./public/uploads/IMG-1691256815123.png")
    .expect(200);

  expect(res.body.data).toBeDefined();
});


test("get user profile - unauthorized", async () => {
  await api
    .get("/api/users/")
    .expect(401);
});

test("get user info by non-existing id", async () => {
  // Mock the findById method to return null for a non-existing user ID
  jest.spyOn(User, "findById").mockResolvedValue(null);

  const nonExistingUserId = new mongoose.Types.ObjectId();
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "test123",
  });

  const token = loginResponse.body.token;

  await api
    .get(`/api/users/${nonExistingUserId}`)
    .set("Authorization", `Bearer ${token}`)
    .expect(404)
    .then((res) => {
      expect(res.body.error).toBe("User not found");
    });

  // Restore the original findById method after the test
  User.findById.mockRestore();
});

test("update user profile - successful update", async () => {
  const res = await api
    .put("/api/users/editProfile")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      fullname: "Updated Fullname",
      bio: "Updated bio",
    })
    .expect(200);

  expect(res.body.data[0].fullname).toBe("Updated Fullname");
  expect(res.body.data[0].bio).toBe("Updated bio");
});

test("update user profile - duplicate username", async () => {
  const existingUser = await User.create({
    username: "existingUserrrr",
    password: "test1234567899",
    fullname: "Existing User",
    email: "existingggg@test.com",
    phone: "123456789999",
  });

  const res = await api
    .put("/api/users/editProfile")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      username: "existingUserrrr",
    })
    .expect(400);

  expect(res.body.error).toBe("Username is already taken");
});

test("update user profile - duplicate email", async () => {
  const existingUser = await User.create({
    username: "existingUserr",
    password: "test1234567899",
    fullname: "Existing User",
    email: "existingg@test.com",
    phone: "12345678999",
  });

  const res = await api
    .put("/api/users/editProfile")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      email: "existingg@test.com",
    })
    .expect(400);

  expect(res.body.error).toBe("Email is already taken");
});

test("update user profile - change phone number", async () => {
  const phone = "1234567890"; // Provide a new phone number here

  const res = await api
    .put("/api/users/editProfile")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      phone: phone,
    })
    .expect(200);

  expect(res.body.data[0].phone).toBe(phone); // Access phone property from the first element of the array
});

test("update user profile - duplicate phone number", async () => {
  const existingUser = await User.create({
    username: "existingUser",
    password: "test123456789",
    fullname: "Existing User",
    email: "existing@test.com",
    phone: "1234567899",
  });

  const res = await api
    .put("/api/users/editProfile")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      phone: "1234567899",
    })
    .expect(400);

  expect(res.body.error).toBe("Phone number is already taken");
});

test("update user profile - unauthorized", async () => {
  const res = await api
    .put("/api/users/editProfile")
    .send({
      fullname: "Unauthorized Update",
    })
    .expect(401);

  expect(res.body.error).toBe("auth token not present");
});

test("update password - incorrect current password", async () => {
  const res = await api
    .put("/api/users/updatePassword")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      currentPassword: "wrongPassword",
      newPassword: "newPassword123",
      confirmPassword: "newPassword123",
    })
    .expect(401);

  expect(res.body.error).toBe("Incorrect current password");
});

test("update password - new password and confirm password do not match", async () => {
  const res = await api
    .put("/api/users/updatePassword")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      currentPassword: "test123",
      newPassword: "newPassword123",
      confirmPassword: "mismatchPassword",
    })
    .expect(400);

  expect(res.body.error).toBe("New password and confirm password do not match");
});

test("update password - new password same as current password", async () => {
  const res = await api
    .put("/api/users/updatePassword")
    .set("Authorization", `Bearer ${validToken}`)
    .send({
      currentPassword: "test123",
      newPassword: "test123",
      confirmPassword: "test123",
    })
    .expect(400);

  expect(res.body.error).toBe(
    "New password must be different from the current password"
  );
});

test("update password - successful", async () => {
  const res = await api
    .put("/api/users/updatePassword")
    .set("Authorization", `Bearer ${validToken}`) // Use the stored token
    .send({
      currentPassword: "test123",
      newPassword: "newPassword123",
      confirmPassword: "newPassword123",
    })
    .expect(204);

  // Perform login with the updated password
  const loginRes = await api
    .post("/api/users/login")
    .send({
      username: "testUser1",
      password: "newPassword123",
    })
    .expect(200);

  expect(loginRes.body.token).toBeDefined();
});


test("delete user - non-existing user", async () => {
  jest.spyOn(User, "findById").mockResolvedValue(null);
  const nonExistingUserId = new mongoose.Types.ObjectId();

  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "newPassword123",
  });

  const token = loginResponse.body.token;

  await api
    .delete(`/api/users/deleteUser/${nonExistingUserId}`)
    .set("Authorization", `Bearer ${token}`)
    .expect(400)
    .then((res) => {
      expect(res.body.message).toBe("User not found");
    });
  // Restore the original findById method after the test
  User.findById.mockRestore();
});

test("delete user - successful", async () => {
  const loginResponse = await api.post("/api/users/login").send({
    username: "testUser1",
    password: "newPassword123",
  });

  const token = loginResponse.body.token;
  const user = await User.findOne({ username: "testUser1" });

  await api
    .delete(`/api/users/deleteUser/${user._id}`)
    .set("Authorization", `Bearer ${token}`)
    .expect(200)
    .then((res) => {
      expect(res.body.message).toBe("User deleted successfully");
    });

  const deletedUser = await User.findOne({ username: "testUser1" });
  expect(deletedUser).toBeNull();
});

afterAll(async () => await mongoose.connection.close())