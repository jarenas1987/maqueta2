class PdfMailer < ApplicationMailer

	def pdf_email(email, pdf_path)
		attachments['experiencia.pdf'] = File.read(pdf_path)
		env = 'postmaster@sandboxde8d041cbc304b568765ff293b5423e5.mailgun.org'
		puts "ENV: #{ENV['username']}"
  	mail_gun_stat = mail(from: env, to: email, subject: 'Prueba de email app maqueta')
	end
end
