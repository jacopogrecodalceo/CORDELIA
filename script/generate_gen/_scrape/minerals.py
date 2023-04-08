import requests
from bs4 import BeautifulSoup

text_file = '/Users/j/Documents/PROJECTs/CORDELIA/script/generate_gen/_data/minerals.txt'

def scrape_in_table(soup_link, string):
	table = soup_link.find('table', class_='infobox')
	if table:
		rows = table.find_all('tr')

		for row in rows:
			th = row.find('th', class_='infobox-label')
			if th and string in th.text.strip():
				td = row.find('td', class_='infobox-data')
				return td.text.strip()

url_contains_list = 'https://en.wikipedia.org/wiki/List_of_minerals'
response = requests.get(url_contains_list)
soup = BeautifulSoup(response.content, 'html.parser')
title = soup.find(id='firstHeading')
print(title.string)

# Get all the links inside url
links = soup.find(id='bodyContent').find_all('a')

for link in links:
	find_pos = link['href'].find('/wiki/')
	if find_pos == 0:
		mineral_link = 'https://en.wikipedia.org' + link['href']
		soup_link = BeautifulSoup(requests.get(mineral_link).content, 'html.parser')
		title = soup_link.find(id='firstHeading').string
		p1 = scrape_in_table(soup_link, 'Mohs')
		p2 = scrape_in_table(soup_link, 'gravity')

		if p1:
			with open(text_file, 'a') as f:
				line = f'{title}, {p1}, {p2}'
				print(line)
				f.write(line + '\n')

