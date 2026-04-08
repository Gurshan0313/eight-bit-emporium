ActiveAdmin.register Province do
  permit_params :name, :abbreviation, :gst, :pst, :hst

  index do
    selectable_column
    id_column
    column :name
    column :abbreviation
    column :gst, :as => :currency, :unit => "%"
    column :pst, :as => :currency, :unit => "%"
    column :hst, :as => :currency, :unit => "%"
    actions
  end

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :abbreviation
      f.input :gst, label: "GST Rate (decimal, e.g., 0.05 for 5%)"
      f.input :pst, label: "PST Rate"
      f.input :hst, label: "HST Rate"
    end
    f.actions
  end
end