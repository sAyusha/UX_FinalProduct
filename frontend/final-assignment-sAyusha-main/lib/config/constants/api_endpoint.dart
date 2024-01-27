class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3001/";
  // static const String baseUrl = "http://192.168.1.70:3001/";

  static const String login = "api/users/login";
  static const String register = "api/users/register";
  static const String getAllUser = "api/users/getAllUsers";
  // static const String getUserImage = "api/users/profileImage/";
  // static const String updateUser = "auth/updateUser/";
  static const String deleteUser = "api/users/deleteUser/";
  static const String profileImageUrl = "http://10.0.2.2:3001/uploads/";
  static const String profilePicture = "api/users/uploadProfilePicture";
  static const String getSavedArts = "api/arts/savedArts/";
  static const String getAlertArts = "api/arts/alertArts/";

  static String saveArt(String artId) => "api/arts/save/$artId";
  static String unsaveArt(String artId) => "api/arts/save/$artId";

  static String alertArt(String artId) => "api/arts/alert/$artId";
  static String unAlertArt(String artId) => "api/arts/alert/$artId";

  // ====================== User Profile Routes ======================
  // static String getUserProfile(String userId) => "api/users/$userId";
  static const String getUser = "api/users/";
  static const String changePassword = "api/users/updatePassword";
  static const String editProfile = "api/users/editProfile";

  // ======================  Art Routes ======================
  static const String postArt = "api/arts/";
  static const String getAllArts = "api/arts/others";
  static String getArtById(String artId) => "api/arts/$artId";
  // static const String updateUser = "auth/updateUser/";
  static const String deleteAllArts = "api/arts/deleteAllArts";
  static const String imageUrl = "http://10.0.2.2:3001/uploads/";
  static const String artPicture = "api/arts/uploadArtPicture";
  static const String getUserArts = "api/arts/myArts";
  static String updateArt(String artId) => "api/arts/$artId";
  static String deleteArt(String artId) => "api/arts/$artId";
  static const String searchArts = "api/arts/search";

  //======================  Bid Routes ======================
  static String postBid(String artId) => "api/bids/$artId/bid";
  static String getAllBids = "api/bids/";
  static String getBid(String bidId) => "api/bids/$bidId";

    //======================  Order Routes ======================
  static String addOrder(String artId) => "api/orders/$artId/order";
  static String getAllOrders(String artId) => "api/orders/$artId/order";
  static String getOrderById(String orderId) => "api/orders/$orderId";
  static String getYourOrder = "api/orders/mine";
  static String updateOrderToPaid(String orderId) =>  "api/orders/$orderId/pay";

  static String getBidStatus = "api/users/";
}
