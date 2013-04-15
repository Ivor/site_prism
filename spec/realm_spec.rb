require 'spec_helper'

describe SitePrism::Realm do
  it "should respond to #page" do
    SitePrism::Realm.should respond_to(:page)
  end

  it "should respond to #realm" do
    SitePrism::Realm.should respond_to(:realm)
  end

  describe "accessing a realm's pages" do
    it "should infer the page from the symbol if no class name is given" do
      class MyPage < SitePrism::Page; end
      class MyRealm < SitePrism::Realm
        page :my_page
      end
      my_realm = MyRealm.new
      my_realm.my_page.should be_a MyPage
    end

    it "should infer the page from the class name if provided" do
      class MyOtherPage < SitePrism::Page; end
      class MyRealm < SitePrism::Realm
        page :my_page, "MyOtherPage"
      end
      my_realm = MyRealm.new
      my_realm.my_page.should be_a MyOtherPage
    end
  end

  describe "accessing a realm's realms" do
    it "should infer the name of the realm if no class name is given" do
      class MySubRealm < SitePrism::Realm; end
      class MyRealm < SitePrism::Realm
        realm :my_sub_realm
      end
      my_realm = MyRealm.new
      my_realm.my_sub_realm.should be_a MySubRealm
    end

    it "should infer the name of the realm if no class name is given" do
      class MyOtherRealm < SitePrism::Realm; end
      class MyRealm < SitePrism::Realm
        realm :my_sub_realm, "MyOtherRealm"
      end
      my_realm = MyRealm.new
      my_realm.my_sub_realm.should be_a MyOtherRealm
    end
  end

  describe "navigating to pages through realms" do
    it "should allow access to pages in nested realms" do
      class UserIndexPage < SitePrism::Page; end
      class UserShowPage < SitePrism::Page; end
      class UsersRealm < SitePrism::Realm
        page :index, "UserIndexPage"
        page :show, "UserShowPage"
      end
      class AdminRealm < SitePrism::Realm
        realm :users, "UsersRealm"
      end
      class AppRealm < SitePrism::Realm
        realm :admin, "AdminRealm"
      end
      app = AppRealm.new
      app.admin.should be_a AdminRealm
      app.admin.users.should be_a UsersRealm
      app.admin.users.index.should be_a UserIndexPage
      app.admin.users.show.should be_a UserShowPage
    end
  end

end