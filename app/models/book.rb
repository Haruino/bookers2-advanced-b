class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy
  
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } 
  # created_atが現在の時刻を含む、今日の始まりから終わりまでの時間範囲（00:00~23:59）にあるデータを検索
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  # created_atが現在の時刻から、1日前の始まりから終わりまでの時間範囲（現在時刻 -1日）にあるデータを検索
  scope :created_2days, -> { where(created_at: 2.days.ago.all_day) }
  scope :created_3days, -> { where(created_at: 3.days.ago.all_day) }
  scope :created_4days, -> { where(created_at: 4.days.ago.all_day) }
  scope :created_5days, -> { where(created_at: 5.days.ago.all_day) }
  scope :created_6days, -> { where(created_at: 6.days.ago.all_day) }
  # ここまでchart.jsのために追加
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
  # created_atが現在の時刻から、6日前の始まりをbeginning_of_dayで00:00に、終わりをend_of_dayで23:59に設定しその時間範囲（現在日 -6日）にあるデータを検索
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 
  # created_atが現在の時刻から、2週間前(14日前)の始まりをbeginning_of_dayで00:00に、終わりをend_of_dayで23:59に設定しその時間範囲（現在日 -14日）にあるデータを検索
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
	
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
