---
title: "CPS 105"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Web Pages

This assignment will give you familiarity with creating a web page (using a template).  There also a (non-required) portion of the assignment where you can purchase your own domain name and use that instead of the github.io one.

## Getting Started

Download the [starting template](/bju/cps105/homework/wp-downloads/template.zip). In this assignment, you will create a personal vCard website. A vCard site is a twenty-first century business card: a small website that consists of a single page. It may include elements such as links to your social media presence; your resume; contact information; and interesting tidbits about yourself. A good vCard site conveys a professional impression and can assist in obtaining employment.

Many online sites can help you generate a vCard website. However, in this assignment you must not use an HTML designer or other online tool. Instead, you must use a text editor such as Notepad++ and work directly with HTML and CSS to create your site.

## Requirements

You will need:

1. A professional photo. If you don’t have one, get a friend to take a “best effort” photo using a cell phone. Tips for a good photo: 1) Wear class dress; 2) Use diffuse natural lighting (avoid direct flash or sunlight; consider shooting outside during the [golden hour](https://en.wikipedia.org/wiki/Golden_hour_(photography))); 3) Use a neutral background.
1. Write a few paragraphs about your activities and interests. You should include at least two links to relevant organizations or sites.
1. The page must be appropriate HTML format with a header section, a page title, and all the visible content in the body. Opening and closing tags should be correctly matched.

Your site may include links to your social media precense, a resume and contact information.

Do not include photographs besides your professional photo.  If you wish to include other photographs, create a separate page and link to it from your vCard.

See the template for an example of what your site should look like.  Feel free to use the structure and design of the template for your site, or change it up if you're feeling adventurous.

## Publishing

You are **required** to publish your website.  Don't worry, it isn't terribly hard. Sign up for an account on [Github](https://github.com).  Remember the username you pick as part of this process, it will be important shortly.

Once you're signed in, click the `New Repository` button.

![New Repository](/bju/cps105/homework/wp-downloads/new-repo.png)

In the repository name, use `<username>.github.io` where `<username>` is the Github username you picked during the signup process.  For example, my github.io page is

![Create Repository](/bju/cps105/homework/wp-downloads/create-repo.png)

Before clicking create, make sure to check the box `Initialize this repository with a README`.

You'll be taken to a page that represents and lists all of the files in your repository.  Right now there is just the `README.md` you asked to be created for you.  Let's fix that.  Click the upload files button.

![Upload Files](/bju/cps105/homework/wp-downloads/upload-files.png)

Drag and drop your `template.html` and photo into the drop area.  Then scroll down and click `Commit changes`.

![Upload Files](/bju/cps105/homework/wp-downloads/upload-complete.png)

Oh no!  The `template.html` actually needs to be named `index.html` but Github will allow you to change that.  Click on the `template.html` and then click the pencil icon.

![Edit Repo](/bju/cps105/homework/wp-downloads/edit-repo.png)

Change the name of the file at the top of the page, then scroll down and click `Commit changes` again.  Notice that you could actually edit your html file as well as change the name.  Feel free to try this out if you like.

Alright, moment of truth.  Try navigating to `<username>.github.io` to see if your page works.

## Learning HTML

If you don’t know HTML, don’t panic! You won’t need to know much HTML for this assignment, if you use the sample template as a starting point. Here are some links to HTML tutorials you may find helpful:

- http://www.w3schools.com/html
- http://www.quackit.com/html/html_tutorial.cfm


## Submission

Create a text document that contains a link to your Github repository (or your Github page).  Submit this via Canvas.

## With Your Own URL

It is now very common for people to have their own web address.  For example, this website is hosted at ethantmcgee.com which is a web address that I own.  How do you do that?  First, a fair warning. This portion of the assignment is optional but requires a small amount of money.

Web addresses, depending on the registrar, will cost you anywhere from $1 to $50 per year, and you can cancel at any time.  Once again, you are **not required** to complete this part of the assignment.

### Sign Up with a Registrar

Create an account with [Namecheap](https://www.namecheap.com).  This registrar is usually very reasonable and incredibly reliable. Once you are logged in, go to the [Domain Name Search](https://www.namecheap.com/domains/domain-name-search.aspx) and enter the web address you would like to purchase.  For example, here are the results for `iheartcps.com`.

![Domain Search](/bju/cps105/homework/wp-downloads/domain-search.png)

Notice that some options (including the one we wanted) is already purchased by someone else.  Don't bother with the `Make Offer`.  Most people owning a domain understandable don't want to sell or will want an unreasonable amount of money for it.  However, Namecheap will offer you alternatives to pick from, or you can search for another domain.

When you've found one you like (and you are comfortable the yearly fee for), click `Add to Cart` then `View Cart`.  You don't need any addons since your website is on Github already so click `Confirm Cart` and complete the checkout process.  (You will need a valid Credit / Debit card for this.  If you don't have one, you can purchase a prepaid credit card at Walmart.)

Once you've completed your purchase, go back to your [dashboard](https://ap.www.namecheap.com/dashboard).  You should see your new domain name listed, with a `Manage` button out to the side.  Click on `Manage`.

![Domain Manage](/bju/cps105/homework/wp-downloads/domain-manage.png)

Scroll down to the nameservers section and change the nameservers to `Custom DNS`.  Open a new tab and create an account on [Cloudflare](https://www.cloudflare.com).

Once logged in, click the `Add Site` button.

![Add Site](/bju/cps105/homework/wp-downloads/add-site.png)

Enter the domain name you just purchased, and when asked which plan you would like to use, select the Free plan.  During the next step, Cloudflare will give you two nameservers to use.  Copy / paste these into Namecheap then save by clicking the green check.

![Custom DNS](/bju/cps105/homework/wp-downloads/custom-dns.png)

Back on Cloudflare, there are likely going to be a lot of junk records from Namecheap. Delete all the existing records by clicking the `X` off to the side.

![Domain Records](/bju/cps105/homework/wp-downloads/domain-record.png)

We're almost at the end.  We need to add one new record to link to Github.  The type should be `CNAME` with a name of `@` (yup just the @ symbol) and a domain of `<username>.github.io` where `<username>` is your Github username.  Also make sure the cloud is orange (click it if it isn't to toggle it).

![New Record](/bju/cps105/homework/wp-downloads/new-record.png)

Final step.  We need to let Github know you have a new custom domain.  Go back to your repository and click the settings tab at the top of the page. Scroll down until you find the `Github Pages` section and then enter your new domain in the `Custom Domain` field. Save.

That should be it!  You will need to wait approximately 24 hours before your site is accessible via the domain name you chose. We will talk about why it takes this long in due time.