const supertest = require('supertest');
const app = require('../app');
const mongoose = require('mongoose');
const Order = require('../models/order');
const User = require('../models/user');
const Art = require('../models/art');
const api = supertest(app);

let token = '';

beforeAll(async () => {
    await User.deleteOne({ username: 'poppss' });
    await api.post('/api/users/register').send({
        fullname: 'Tester User',
        username: 'testUser68',
        email: 'test68@gmail.com',
        phone: '9865109966',
        password: 'tester091234',
    });

    const res = await api.post('/api/users/login').send({
        username: 'testUser68',
        password: 'tester091234',
    });

    token = res.body.token;
    // Create a sample user
    const user = new User({
        fullname: 'Testing',
        username: 'poppss',
        email: 'poppss@gmail.com',
        phone: '9865109866',
        password: 'poppss12',
    });
    await user.save();

    // Create a sample art
    const art = new Art({
        image: 'image.jpg',
        title: 'Sample Art',
        description: 'This is a sample art',
        creator: 'Sample Artist',
        startingBid: 100,
        endingDate: new Date(Date.now() + 86400000), // Set the ending date to 24 hours from now
    });
    await art.save();

    // Create a sample order
    const order = new Order({
        orderItems: [{
            image: 'image.jpg',
            title: 'Sample Art',
            description: 'This is a sample art',
            art: art._id,
        }],
        shippingAddress: {
            fullname: 'John Doe',
            address: '123 Main St',
            postalCode: '12345',
            city: 'New York',
            request: 'Please handle with care',
        },
        paymentMethod: 'COD',
        bidAmount: 100,
        shippingPrice: 10,
        totalAmount: 110,
        user: user._id,
    });
    await order.save();
});

test('user can create an order', async () => {
    const orderData = {
        orderItems: [{
            image: 'image.jpg',
            title: 'Sample Art',
            description: 'This is a sample art',
            artId: '5f9d7b7b9d1e9e2a3c8f9b9b',
        }],
        shippingAddress: {
            fullname: 'John Doe',
            address: '123 Main St',
            postalCode: '12345',
            city: 'New York',
            request: 'Please handle with care',
        },
        paymentMethod: 'COD',
        bidAmount: 100,
        shippingPrice: 10,
        totalAmount: 110,
    };
    await api
        .post(`/api/orders/${orderData.orderItems[0].artId}/order`)
        .set('Authorization', `Bearer ${token}`)
        .send(orderData)
        .expect(201)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.data).toBeDefined();
        });
});

test('user can get all orders', async () => {
    await api
        .get('/api/orders/')
        .set('Authorization', `Bearer ${token}`)
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.data).toBeDefined();
        });
});

test('user can get their orders', async () => {
    const user = await User.findOne({ username: 'testUser68' });

    // Create a sample order for the user
    const orderData = {
        orderItems: [{
            image: 'image.jpg',
            title: 'Sample Art',
            description: 'This is a sample art',
            artId: '5f9d7b7b9d1e9e2a3c8f9b9b',
        }],
        shippingAddress: {
            fullname: 'John Doe',
            address: '123 Main St',
            postalCode: '12345',
            city: 'New York',
            request: 'Please handle with care',
        },
        paymentMethod: 'COD',
        bidAmount: 100,
        shippingPrice: 10,
        totalAmount: 110,
        user: user._id,
    };

    // Create the sample order
    const order = new Order(orderData);
    await order.save();

    await api
        .get('/api/orders/mine')
        .set('Authorization', `Bearer ${token}`)
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.data).toBeDefined();
        });
});

test('user can get an order by id', async () => {
    const order = await Order.findOne();
    await api
        .get(`/api/orders/${order._id}`)
        .set('Authorization', `Bearer ${token}`)
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.data).toBeDefined();
        });
});

test('user can delete an order', async () => {
    const order = await Order.findOne();
    await api
        .delete(`/api/orders/${order._id}`)
        .set('Authorization', `Bearer ${token}`)
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe('Order removed');
        });
});

test('user can update an order to paid', async () => {
    const order = await Order.findOne({ isPaid: false });
    await api
        .put(`/api/orders/${order._id}/pay`)
        .set('Authorization', `Bearer ${token}`)
        .send({
            id: 'transactionId',
            status: 'success',
            update_time: '2023-08-01T12:34:56Z',
            email_address: 'user@example.com',
        })
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe('Order paid successfully');
        });
});

test('user can update an order to delivered', async () => {
    const order = await Order.findOne({ isDelivered: false });
    await api
        .put(`/api/orders/${order._id}/deliver`)
        .set('Authorization', `Bearer ${token}`)
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .then((res) => {
            expect(res.body.message).toBe('Order delivered');
        });
});

afterAll(async () => {
    await Order.deleteMany();
    await User.deleteMany();
    await Art.deleteMany();
    await mongoose.connection.close();
});
