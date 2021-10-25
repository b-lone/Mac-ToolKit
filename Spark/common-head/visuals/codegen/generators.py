from abc import ABCMeta, abstractmethod
import os
import jinja2

import general_utils


class AbstractGenerator:
    __metaclass__ = ABCMeta

    @abstractmethod
    def generate(self, out_filename, template, **kwargs):
        pass

    @abstractmethod
    def get_state(self):
        pass


class Generator(AbstractGenerator):
    def __init__(self, name, output_folder, templates_folders):
        super(AbstractGenerator, self).__init__()
        self.name = name
        self.output_folder = output_folder
        self.env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_folders))

    def generate(self, out_filename, template, **kwargs):
        out_filename = self.get_path(out_filename)
        with open(out_filename, 'w') as out_file:
            out_file.write(self.render_template(template, **kwargs))

    def get_state(self):
        return f'{self.name} code generation complete!'

    def get_path(self, filename):
        return os.path.join(self.output_folder, filename)

    def render_template(self, name, **kwargs):
        kwargs['utils'] = general_utils
        return self.env.get_template(name).render(kwargs)


class PrintingGenerator(AbstractGenerator):
    def __init__(self, output_folder):
        super(AbstractGenerator, self).__init__()
        self.output_folder = output_folder
        self.all_files = set()

    def generate(self, out_filename, template, **kwargs):
        self.all_files.add(self.get_path(out_filename))

    def get_state(self):
        return '\n'.join(self.all_files)

    def get_path(self, filename):
        return os.path.join(self.output_folder, filename)
