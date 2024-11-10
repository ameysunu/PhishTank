using Google.Cloud.Firestore;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace PhishTankGCPRun
{
    public class Monitoring
    {
        public async Task StartMonitoringEngine()
        {
            var fireStoreKeyBase64 = "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiaW9zLXByb2plY3QtMTFjMzQiLAogICJwcml2YXRlX2tleV9pZCI6ICJkMzcxMWFhNjJjMGE4MzQyNmYwZWYwZWEzMzJhNWZjZmVkZTY3MGI5IiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdlFJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLY3dnZ1NqQWdFQUFvSUJBUUMzSlhnR0xEaDQweDFhXG5JWVlpWDVZNnNGRTIwYmFxSFFCME1XaTZmcm9mUldweVZFU1RYS3ZSLzRKRy9RQjVDcjZHWUtuMzRlZVFveUJiXG51MHl2eVdoT2Z5cGlxSFNwaElycHF1NlRRcVhnOHRIRUV5VXhPWkx0WkJZZkFnREh3Lzlib1NZSDh0dmlEVG1OXG5DdUhqN2gxRGY3eFBaMU9yazExSzBMQlJCSUMzQ010ZXVjdVkwSENJcUppVU85MjBxaVk4TTJGTUltT3dUeUU0XG51Tm00by9VUithR3hLSVdxSElhcHFVUHNJcGRCMk5pejBmYTd1Q1ZNbVU2aWg1ZHdCL1hROWZGY3c5b1RSaGZRXG4wL1Jxc0NaYXFlbzIzMXoyWlN3djFXSkVCdjNjdmtvUTVXMGw3WFEzV0srK2c3YkpuRlE1OXNRRzhUeWZMY3dPXG5ITE1DRVJKcEFnTUJBQUVDZ2dFQUY5SGV1aEYyOHMxUHR2dVVqTlNaSHdtZTRSNEdGT1ZGWnRkUG1LOHlHUzV0XG5Ec1pEbzZyYzMxTjNwOXRGL0NMWDdzcnBzRWRkclE1dnFmUHRTeEQxNlAwRVpUcDY3eS9zT3BjMFdrdHVkRU1BXG5qSnVLTGN4MWZlYytNcUE1dThHVHdtRERmU3Nxbi9ibEI2RmxDY0VHdTFNRXRJc1ZjeGp0SnZXSGM3SVRPanJKXG5RZG1JZ3dKQkxmZjU1bWx5TWtxSnB0eUJSVE4xUlpsMnpqeWd2SElRTnJ2NHFZMVhCeHFqKzI3allHMXBhMyt5XG51TUs1UiswOUhkdVZwaHF5eWVxWjJtZm1Gc0tnUks5Yk53emxBcmtxWTYvMXUrT1VDcGE2Y0ZVSy9GSC9GU1lSXG5ESzBIWjRCYVRmKzB2WWJNbXlTaTY2WkNBMENtM2pqU3RZV2NLc1ArMVFLQmdRRGJHWDcvVkZ4VXRxbS9RNnZpXG5TT2JjRzFqNjhVeklmU0p5Y29oZU1vTjZQbEc5aXdUSTlocG45YytLOFlWanVDMFJWSUwwWVh4WWJCanAzNW0yXG5UM05oajZ3R3RzaEpCY0RBcWVjNjZrMmpQbVlPT2lnMDdWUUlOZHJ1UVNpZnlzamtibTBCWUpUZTVnRFRaR1FiXG4rTjVlWENWWEdvU3d5WDFZMXNqaVNkRHNSd0tCZ1FEVi9kaFlkYjhUOUdaWm5rOWtCRzhMdkZXbFByRFBkUlpPXG5Jamg3ZmQrZ1pUbWsrTUlVUDc4Y2h5STYvSnpZY29CUUhRcEtRN0ZGcHAvNzg3bGM5WWVwVVpXcTVYa2d4Q3RGXG5ldFlqSDJQQUN6bXMxcHBZaVF5QkkrUXdPOGljV0tvSkl6bFJMTUt0NVNGYldWT01zMzNiRzRycWJpNWFKdmg1XG5SY3RSN01GVHp3S0JnUURJNS8wekpta3Y2UHVJZmdZY0RsdGJFOXlvNXlGUWFxWnVxYVZ3TXdPcTBZQmt2UmhiXG5Lb2lXTWFucEw0VHdKczkwcDdrWlhGY0lRYjhxbmJXMm5lNGdWUDBhZnZyek1zcElJTVArbXlFc0FxalVmUEduXG5ic1J5YnVmZE4zU0g2Z3dDbzF0ak91dm41S0ozTlFRelBpYXlBZTdmaTFxSFBZdXFMZkd3eHAxRU93S0JnQ05OXG5xYStPWFdPeFltRk9tTkpyV05hYXo1WmZiVlFNZ1EySzM3NmYyWkRnb2szeExET2pBS2g0TXRHQWMyL1NGQkVqXG5lVnNmSjlQUjFYci9qb2tqaUtvS1o2SzJFUEd5NjJDZkQwemtGTlRPQlVuYWJjUkZkK2FtUVRNajZjakJaK3Z4XG4vN2JBcDYyQXE2d2laSUpGNm5HSGJiZVhUZFpacjR4eVUwVEV4bkJKQW9HQUNHdHFpcnFPQkt6dy9SN0pVL1JzXG5makovMnNoRnF3M2JMdFNjS3RLNDd1c2FFcUxtMmZ1WUZtT1FacFA0Qk1iNmUvdTNsUlVTc09zZ3RqQXNpT0Q1XG5CM3hQcGZSQ3VielRQL2N1aDBxT2E2bDQyNW5XNkcwMkVqUXNReFRSY25mQjg2YkpUaXRHN1JhVzMrQ25Bd1o4XG5nelhqbFZ0ZjlOMXA2OEZSTVVuWXMzYz1cbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJmaXJlYmFzZS1hZG1pbnNkay01dGd2Y0Bpb3MtcHJvamVjdC0xMWMzNC5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMDE0MzYyMDMwOTAxODM1MTE4OTMiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L2ZpcmViYXNlLWFkbWluc2RrLTV0Z3ZjJTQwaW9zLXByb2plY3QtMTFjMzQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLAogICJ1bml2ZXJzZV9kb21haW4iOiAiZ29vZ2xlYXBpcy5jb20iCn0K";
            var serviceAccountKey = Encoding.UTF8.GetString(Convert.FromBase64String(fireStoreKeyBase64));

            Firebase firebaseCtrl = new Firebase();
            FirestoreDb firestoreDb = await firebaseCtrl.InitializeFirestoreDb(serviceAccountKey);

            var phishingData = await GetGroupedDocumentsAsync(firestoreDb, "phishtank-phish-data");
            var breachData = await GetGroupedDocumentsAsync(firestoreDb, "phishtank-breach-data");

            if (phishingData != null)
            {
                foreach (var doc in phishingData)
                {
                    Console.WriteLine($"Document Id: {doc.Key}");

                    foreach(var docVal in doc.Value)
                    {
                        Console.WriteLine($"textVal: {docVal.textValue}");
                    }
                }
            }


            if (breachData != null)
            {
                foreach (var breachDoc in breachData)
                {
                    Console.WriteLine($"Document Id: {breachDoc.Key}");

                    foreach (var docVal in breachDoc.Value)
                    {
                        Console.WriteLine($"textVal: {docVal.textValue}");
                    }
                }
            }

        }

        public static async Task<Dictionary<string, List<PayloadData>>> GetGroupedDocumentsAsync(FirestoreDb db, string collectionName)
        {
            try
            {
                CollectionReference collection = db.Collection(collectionName);
                QuerySnapshot snapshot = await collection.GetSnapshotAsync();

                var groupedDocs = new Dictionary<string, List<PayloadData>>();

                foreach (DocumentSnapshot document in snapshot.Documents)
                {
                    if (!document.Exists)
                    {
                        Console.WriteLine($"Document not found: {document.Id}");
                        continue;
                    }

                    string documentId = document.Id;
                    string googleId = documentId.Split('-')[0];

                    PayloadData payloadData = new PayloadData
                    {
                        id = documentId,
                        textValue = document.ContainsField("textValue") ? document.GetValue<string>("textValue") : null,
                        geminiResult = document.ContainsField("geminiResult") ? document.GetValue<string>("geminiResult") : null,
                        type = document.ContainsField("type") ? document.GetValue<bool>("type") : false
                    };

                    if (!groupedDocs.ContainsKey(googleId))
                    {
                        groupedDocs[googleId] = new List<PayloadData>();
                    }
                    groupedDocs[googleId].Add(payloadData);
                }

                return groupedDocs;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching documents: {ex.Message}");
                return new Dictionary<string, List<PayloadData>>();
            }
        }

    }

    public class MonitoringController : ControllerBase
    {
        [HttpGet("monitoring")]
        public async Task<ActionResult<string>> Get()
        {
            try
            {
                Monitoring mtr = new Monitoring();
                await mtr.StartMonitoringEngine();

                return "Success";
            } catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
