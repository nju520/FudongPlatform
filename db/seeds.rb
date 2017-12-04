buyer_1 = User.create(email: "buyer_1@qq.com", password: '111111', password_confirmation: '111111', uuid: RandomCode.generate_utoken)

buyer_1 = User.create(email: "buyer_1@qq.com", password: '111111', password_confirmation: '111111', uuid: RandomCode.generate_utoken)

seller_1 = User.create(email: "seller_1@qq.com", password: '111111', password_confirmation: '111111', uuid: RandomCode.generate_utoken,  is_seller: true)

seller_2 = User.create(email: "seller_2@qq.com", password: '111111', password_confirmation: '111111', uuid: RandomCode.generate_utoken,  is_seller: true)


admin = User.create(email: "admin@qq.com", password: '111111', password_confirmation: '111111', is_admin: true, uuid: RandomCode.generate_utoken)

AdminAccount.create(name: 'PlatformAccount', balance: 0.0)
