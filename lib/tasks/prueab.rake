namespace :prueab do
	desc "Task description"
	task :prueba => :environment do
		pdf = Pdf.new()
    pdf.render_file(Rails.root.join('public', 'prueba.pdf'))
	end
end
