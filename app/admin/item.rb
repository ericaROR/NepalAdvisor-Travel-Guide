ActiveAdmin.register Item do
 
 
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
   permit_params :list, :of, :attributes, :on, :model, :Name, :Description, :category_id, descriptions_attributes: [ :id, :Title, :Description, :Order ],images_attributes: [ :id, :Title, :Description, :Order, :image ]
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  index do 
    column :Name
    column :category do |c|
        link_to c.category.Name
      end
    column :Description
    column :Order
     column "" do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      links
    end
  end

  form do |f|
    f.inputs "Item" do
      # add your other inputs
      f.input :category, :collection => Category.all.map{ |category| [category.Name, category.id] },:prompt => true
      f.input :Name
      f.input :Description
      f.input :Order
     end 

     

      f.inputs do
        f.has_many :images, new_record: 'Images' do |b|
          b.input :Title
           b.input :Content
           b.input :Order
          b.input :image
        end
      end

        f.inputs do
        f.has_many :descriptions, new_record: 'Descriptions' do |d|
          d.input :Title
           d.input :Content
           d.input :Order
        end
      end


     
     f.actions 
   end

   show do
    attributes_table :categroy, :Name, :Description, :Order
  end


  show do
  attributes_table do
    row :Name
    row :Description

    row :category do |c|
        link_to c.category.Name, [ :admin, c ]
      end
    
  end
end


filter :category 
filter :Name 
filter :Description
filter :category, as: :select, collection: -> {Category.all.map{|s| [s.Name,s.id]}.uniq},  input_html: { class: 'chosen-input' } #or as you've shown before, using pluck :)

end