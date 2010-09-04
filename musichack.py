# Server for music touch explorer

import mdp
import web
import json
import urllib
import scipy

urls = (
    '/(.*)', 'songdata'
)
app = web.application(urls, globals())

class songdata:        
    def GET(self, name):
        min,max=[],[]
        if not name: 
          names="&artist=the+beatles"
        else:
          names=""
          for n in name.split(','):
            names = names + "&artist=" +n
        rawdata = json.loads(urllib.urlopen("http://developer.echonest.com/api/v4/playlist/static?api_key=N6E4NIOVYMTHNDM8J&artist=%s&format=json&results=100&type=artist-radio&bucket=id:7digital&bucket=audio_summary&audio=true&variety=0.999"%(names)).read())['response']["songs"]
        keys = [u'key', u'tempo', u'mode', u'time_signature', u'duration', u'loudness']
        x=[]
        for s in rawdata:
            x.append([])
            for k in keys:
              x[-1].append(s['audio_summary'][k])
        y = mdp.fastica(scipy.array(x))
        maxc,minc = [],[]
        for col in range(len(keys)):
          maxc.append(y[:, col].max())
          minc.append( y[:, col].min())
        for col in range(len(keys)):
          rang = maxc[col] - minc[col]
          for row in range(100):
            y[row,col] = (y[row,col] - minc[col])/rang
        return json.dumps({'characteristics_keys':keys, 'characteristics':x, 'ica':y.tolist() , 'echo':rawdata})

if __name__ == "__main__":
    app.run()

