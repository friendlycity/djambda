import MySQLdb
from django.conf import settings
from django.core.management.base import BaseCommand, CommandError

class Command(BaseCommand):
    help = "Creates database command"

    def add_arguments(self, parser):
        parser.add_argument("db_name")
        parser.add_argument("--exist_ok", action="store_true")

    def handle(self, *args, **options):
        db = MySQLdb.connect(
            user=settings.DATABASES["default"]["USER"],
            passwd=settings.DATABASES["default"]["PASSWORD"],
            host=settings.DATABASES["default"]["HOST"],
            port=settings.DATABASES["default"]["PORT"]
        )
        try:
            with db.cursor() as cursor:
                cursor.execute(f"CREATE DATABASE \"{options['db_name']}\"")
            print('CreateDB success')
        except MySQLdb.DatabaseError:
            print('Database already exists')
            if not options["exist_ok"]:
                raise CommandError('Database "%s" already exists' % options["db_name"])
        else:
            self.stdout.write(
                self.style.SUCCESS(
                    'Successfully created database "%s"' % options["db_name"]
                )
            )
