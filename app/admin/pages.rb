ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  # No scaffold — custom form only (per feature 1.4 requirement)
  actions :all, except: []

  index do
    id_column
    column :title
    column :slug
    actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content
    end
  end

  form do |f|
    f.inputs "Page Content" do
      f.input :title
      f.input :slug, hint: "URL-friendly name e.g. 'about' or 'contact'"
      f.input :content, as: :text, input_html: { rows: 15 }
    end
    f.actions
  end
end