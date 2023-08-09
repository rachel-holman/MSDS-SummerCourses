#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 10 16:28:04 2022

@author: jk8sd
"""

import numpy as np
import pandas as pd
import requests
import json
import plotly.express as px
import plotly.figure_factory as ff
import dash
from datetime import timedelta
from dash import dcc
from dash import html
from dash import dash_table
from dash.dependencies import Input, Output

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

my_markdown = '''
Data are compiled from the Virginia Dept. of Health. API endpoint: [https://data.virginia.gov/resource/bre9-aqqr.json](https://data.virginia.gov/resource/bre9-aqqr.json)
'''

endpoint = 'https://data.virginia.gov/resource/bre9-aqqr.json'
mypars = {'$limit': 200000}
headers = {'User-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:99.0) Gecko/20100101 Firefox/99.0'}
r = requests.get(endpoint, params=mypars, headers=headers)

cases = pd.json_normalize(json.loads(r.text))
cases['report_date'] = pd.to_datetime(cases['report_date'])
cases['total_cases'] = cases['total_cases'].astype('int')
cases['hospitalizations'] = cases['hospitalizations'].astype('int')
cases['deaths'] = cases['deaths'].astype('int')

cases_today = cases.loc[cases['report_date'] == max(cases['report_date'])]

url = "https://demographics.coopercenter.org/sites/demographics/files/media/files/2020-07/Census_2019_RaceEstimates_forVA_0.xls"
pop = pd.read_excel(url, skiprows=4)
pop = pop.loc[~pop['FIPS'].isna()]
pop['FIPS'] = pop['FIPS'] + 51000
pop['FIPS'] = pop['FIPS'].astype('int').astype('str')
pop = pop[['FIPS', 'Total Population']]

cases_pop = pd.merge(cases_today, pop, 
                    left_on = ['fips'],
                    right_on = ['FIPS'],
                    how = 'inner')
cases_pop['Cases per 1000 people'] = round(1000*cases_pop['total_cases']/cases_pop['Total Population'],1)
cases_pop['Hospitalizations per 1000 people'] = round(1000*cases_pop['hospitalizations']/cases_pop['Total Population'],1)
cases_pop['Deaths per 1000 people'] = round(1000*cases_pop['deaths']/cases_pop['Total Population'],1)

cases_trend = cases[['report_date', 'fips', 'locality', 'total_cases', 'hospitalizations', 'deaths']]
cases_trend = pd.melt(cases_trend, id_vars = ['report_date', 'fips', 'locality'],
                     value_vars = ['total_cases', 'hospitalizations', 'deaths'])
cases_trend['date14'] = cases_trend['report_date'] + timedelta(14)
cases_trend['date28'] = cases_trend['report_date'] + timedelta(28)
cases_trend = pd.merge(cases_trend, cases_trend,
                      right_on = ['report_date', 'fips', 'locality', 'variable'],
                      left_on = ['date14', 'fips', 'locality', 'variable'])

cases_trend = cases_trend.drop(['report_date_x','date14_x','date28_x'], axis=1)
cases_trend = cases_trend.rename({'report_date_y':'report_date',
                                 'date14_y':'date14',
                                 'date28_y':'date28',
                                 'value_y':'value',
                                 'value_x':'value14'}, axis=1)
cases_trend = pd.merge(cases_trend, cases_trend,
                      right_on = ['report_date', 'fips', 'locality', 'variable'],
                      left_on = ['date28', 'fips', 'locality', 'variable'])

cases_trend = cases_trend.drop(['report_date_x','date14_y','date28_y', 'value14_x', 'date14_x', 'date28_x'], axis=1)
cases_trend = cases_trend.rename({'report_date_y':'report_date',
                                 'value_y':'value',
                                 'value14_y':'value14',
                                 'value_x':'value28'}, axis=1)
cases_trend['Most recent 14 days'] = cases_trend['value'] - cases_trend['value14']
cases_trend['Previous 14 days'] = cases_trend['value14'] - cases_trend['value28']
cases_trend['Trend'] = 100*(cases_trend['Most recent 14 days'] - cases_trend['Previous 14 days']) / cases_trend['Previous 14 days']
cases_trend['Trend_string'] = round(cases_trend['Trend'], 1).astype('str') + "%"

url = 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
r = requests.get(url)
counties = json.loads(r.text)

vamap = px.choropleth(cases_pop,
                   locations = 'fips',
                   geojson=counties,
                   color='Cases per 1000 people',
                   color_continuous_scale="reds",
                   scope="usa",
                   height = 600,
                   width= 1000,
                   hover_name = 'locality',
                   hover_data = ['Hospitalizations per 1000 people',
                                'Deaths per 1000 people'])
vamap.update_geos(fitbounds='locations')
vamap.update_layout(margin={"r":0,"t":0,"l":0,"b":0})


######################

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div(
    [
     html.H1("Current COVID Statistics for Virginia"),
     dcc.Markdown(children = my_markdown),
     dcc.Graph(figure=vamap),

     html.Div([dcc.Dropdown(id = 'places',
                  options=[{'label': i, 'value': i} for i in cases['locality'].unique()],
                  value = 'Charlottesville'),
               dcc.Graph(id = 'table')], style = {'width':'48%', 'float':'left'}),
     html.Div(dcc.Graph(id = 'graph'), style = {'width':'48%', 'float':'right'}),
     
     ]
    )

@app.callback(Output(component_id="graph",component_property="figure"),
              Input(component_id='places',component_property="value"))

def myline(loc):
    ct = cases_trend.query(f'locality=="{loc}" & variable=="total_cases"')
    fig = px.line(ct, x = 'report_date',
             y = 'value',
             title = f'Total COVID Cases: {loc}',
             labels = {'value': 'Total COVID cases',
                      'report_date': 'Date'})
    fig.update(layout=dict(title=dict(x=0.5)))

    return fig

@app.callback(Output(component_id="table",component_property="figure"),
              Input(component_id='places',component_property="value"))

def mytable(loc):
    ct = cases_trend.query(f'locality=="{loc}"')
    ct = ct.loc[ct['report_date'] == max(ct['report_date'])]
    ct['variable'] = ct['variable'].replace({'total_cases':'Total COVID cases',
                                        'hospitalizations':'Hospitalizations',
                                        'deaths':'Deaths'})
    ct = ct[['variable', 'value', 'Most recent 14 days',
         'Previous 14 days', 'Trend_string']]
    ct = ct.rename({'variable':'',
               'value':'Total since March 2020',
               'Trend_string': 'Trend'}, axis=1)
    table = ff.create_table(ct)
    return table

if __name__ == '__main__':
    app.run_server(debug=True)
    