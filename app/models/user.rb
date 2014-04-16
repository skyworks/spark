class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not an email") unless
    value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  end                          
end 

class User < ActiveRecord::Base
  validates :email, :presence => true, 
    :email => true,                 
    :uniqueness => { :case_sensitive => false } 
  validates :password, :presence => true
  validates :nickname, :presence => true
  validates :salt, :presence => true

  def self.register(email, password)  
    if email != nil and !email.empty? and password != nil and !password.empty?
      user = User.find(:first, :conditions => { :email => email })
      if user == nil           
        user = User.new        
        user.email = email.downcase     
        user.salt = Digest::SHA1.hexdigest("#{Time.now.utc}--#{password}")
        user.password = Digest::SHA1.hexdigest("#{user.salt}--#{password}")
        user.nickname = email.downcase  
        return user.save       
      end                      
    end                        

    false                      
  end   

  def self.login(email, password) 
    if email != nil and !email.empty? and password != nil and !password.empty?
      user = User.find(:first, :conditions => { :email => email.downcase })
      return user if user != nil and user.check_password(password)
    end                        

    nil
  end

  def check_password(temp)     
    password == Digest::SHA1.hexdigest("#{salt}--#{temp}")
  end

end
