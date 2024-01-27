const supertest = require('supertest');
const app = require('../app');
const mongoose = require('mongoose');
const User = require('../models/user');
const Art = require('../models/art');
const Bid = require('../models/bid');
const api = supertest(app);

let token = '';

beforeAll(async () => {
  await User.deleteMany({});
  await api.post('/api/users/register').send({
    fullname: 'Testuserrr',
    username: 'testUser3',
    email: 'test3@gmail.com',
    phone: '9865109099',
    password: 'tester123',
  });

  const res = await api.post('/api/users/login').send({
    username: 'testUser3',
    password: 'tester123',
  });

  token = res.body.token;
});

test('user can place a valid bid', async () => {
  // Prepare the bidAmount for placing the bid
  const bidAmount = 150;
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();
  // Create a sample user object for testing
  const sampleUser = new User({
    fullname: 'Tester',
    username: 'testUser4',
    email: 'test00@gmail.com',
    phone: '9865109000',
    password: 'tester1200',
  });
  await sampleUser.save();

  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount })
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      // Assert that the bid was placed successfully
      expect(res.body.data).toBeDefined();
      expect(res.body.data.bidAmount).toBe(bidAmount);
    });
});

test('user can get a bid by id', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();
  // Create a sample user object for testing
  const sampleUser = new User({
    fullname: 'Testerr',
    username: 'testUser99',
    email: 'test99@gmail.com',
    phone: '9865109044',
    password: 'tester1290',
  });
  await sampleUser.save();
  // Create a sample bid object for testing
  const sampleBid = new Bid({
    bidAmount: 100,
    bidArt: sampleArt._id,
    user: sampleUser._id,
  });
  await sampleBid.save();

  await api
    .get(`/api/bids/${sampleBid._id}`)
    .set('Authorization', `Bearer ${token}`)
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
      expect(res.body.data).toHaveLength(1);
    });
});

test('user cannot retrieve a bid with an invalid bid ID', async () => {
  const invalidBidId = 'invalidBidId'; // Invalid bid ID format
  await api
    .get(`/api/bids/${invalidBidId}`)
    .set('Authorization', `Bearer ${token}`)
    .expect(404)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.message).toBe('Bid not found');
    });
});

test('user cannot retrieve a bid with non-existing bid ID', async () => {
  const nonExistingBidId = '616e21ea9ac29a1a49a13627'; // A random non-existing bid ID
  await api
    .get(`/api/bids/${nonExistingBidId}`)
    .set('Authorization', `Bearer ${token}`)
    .expect(404)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.message).toBe('Bid not found');
    });
});

// Test case for retrieving a bid with valid bid ID and populating related data
test('user can retrieve a bid with populated related data', async () => {
  // Create a sample user object for testing
  const sampleUser = new User({
    fullname: 'Test Userlll',
    username: 'testUserlll',
    email: 'testalll@example.com',
    phone: '1234567111',
    password: 'test123llll',
  });
  await sampleUser.save();
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
    highestBidAmount: 100,
    highestBidder: sampleUser._id,
  });
  await sampleArt.save();
  // Create a sample bid object for testing
  const sampleBid = new Bid({
    bidAmount: 100,
    bidArt: sampleArt._id,
    user: sampleUser._id,
  });
  await sampleBid.save();

  await api
    .get(`/api/bids/${sampleBid._id}`)
    .set('Authorization', `Bearer ${token}`)
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
      expect(res.body.data[0]._id).toBe(sampleBid._id.toString());
      expect(res.body.data[0].user).toBeDefined(); // User data should be populated
      expect(res.body.data[0].bidArt).toBeDefined(); // Art data should be populated
    });
});


test('user can get all bids', async () => {
  await api
    .get('/api/bids/')
    .set('Authorization', `Bearer ${token}`)
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
    });
});

test('should handle internal server error', async () => {
  // Mock a function to throw an error
  jest.spyOn(Bid, 'find').mockImplementation(() => {
    throw new Error('Test error');
  });

  // Perform the request
  const response = await supertest(app)
    .get('/api/bids')
    .set('Authorization', `Bearer ${token}`);

  // Assertions
  expect(response.status).toBe(500);
  expect(response.body.message).toBe('Internal server error');
});

test('user cannot place a bid on a non-existing artwork', async () => {
  const nonExistingArtId = '616e21ea9ac29a1a49a13627'; // A random non-existing art ID
  const bidAmount = 100;
  await api
    .post(`/api/bids/${nonExistingArtId}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount })
    .expect(404)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.message).toBe('Art not found');
    });
});

test('user cannot place a bid on an expired artwork', async () => {
  // Create a sample art object for testing with an expired ending date
  const expiredArt = new Art({
    image: 'image1.jpg',
    title: 'Expired Art',
    description: 'This is an expired artwork',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() - 86400000), // Set the ending date to 24 hours ago (expired)
  });
  await expiredArt.save();

  const bidAmount = 100;
  await api
    .post(`/api/bids/${expiredArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount })
    .expect(403)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.error).toBe('Art has expired and cannot be updated');
    });
});

test('user cannot place a bid lower than the starting bid amount', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();

  const lowerBidAmount = 40; // Attempt to place a bid lower than the starting bid
  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount: lowerBidAmount })
    .expect(400)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.message).toBe('Bid amount must be greater than the current bid.');
    });
});

test('user cannot place a bid equal to the starting bid', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();

  const startingBidAmount = 50;
  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount: startingBidAmount })
    .expect(400)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.message).toBe('Bid amount must be greater than the current bid.');
    });
});

test('user can place a bid higher than the current highest bid', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
    highestBidAmount: 100, // Set a higher initial bid
  });
  await sampleArt.save();

  const higherBidAmount = 150; // Place a bid higher than the current highest bid
  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount: higherBidAmount })
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.data).toBeDefined();
      expect(res.body.data.bidAmount).toBe(higherBidAmount);
    });
});

test('user cannot place a bid with an invalid bid amount', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();

  const invalidBidAmount = -50; // Negative bid amount
  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount: invalidBidAmount })
    .expect(400)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.message).toBe('Bid amount must be greater than the current bid.');
    });
});

test('user cannot place a bid without authentication', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();

  const bidAmount = 150;
  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .send({ bidAmount }) // No Authorization header set
    .expect(401)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      expect(res.body.error).toBe('auth token not present');
    });
});

test('user can update a bid if the art is not expired', async () => {
  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();

  // Create a sample user object for testing
  const sampleUser = new User({
    fullname: 'Tester Userr',
    username: 'testUser1001',
    email: 'test1001@gmail.com',
    phone: '9865109072',
    password: 'tester1200',
  });
  await sampleUser.save();

  // Create a sample bid object for testing
  const sampleBid = new Bid({
    bidAmount: 100,
    bidArt: sampleArt._id,
    user: sampleUser._id,
  });
  await sampleBid.save();

  const updatedBidAmount = 150;
  await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount: updatedBidAmount })
    .expect(200)
    .expect('Content-Type', /application\/json/)
    .then((res) => {
      // Assert that the bid was updated successfully
      expect(res.body.data).toBeDefined();
      expect(res.body.data.bidAmount).toBe(updatedBidAmount);
    });
});

test('should handle internal server error', async () => {
  // Mock User.findById to throw an error
  jest.spyOn(User, 'findById').mockImplementation(() => {
    throw new Error('Test error');
  });

  // Create a sample art object for testing
  const sampleArt = new Art({
    image: 'image1.jpg',
    title: 'Test Art',
    description: 'This is a test art',
    creator: 'Test User',
    startingBid: 50,
    endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
  });
  await sampleArt.save();

  const bidAmount = 150;

  // Perform the request
  const response = await api
    .post(`/api/bids/${sampleArt._id}/bid`)
    .set('Authorization', `Bearer ${token}`)
    .send({ bidAmount });

  // Assertions
  expect(response.status).toBe(500);
  expect(response.body.message).toBe('Internal server error');
});



afterAll(async () => await mongoose.connection.close())

